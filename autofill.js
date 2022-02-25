function autofill(root, error_handler, done_callback) {

	/*
	 * Applies func to each item in list.  This functions works
	 * with HTMLCollections, argument lists and normal javascript
	 * arrays.
	 */
	function each(list, func) {
		for (var i = 0; i < list.length; i++)
			func(list[i]);
	}

	/*
	 * Merges the given objects into a fresh object.  Properties
	 * found in objects further back in the argument list take
	 * precedence over properties found in previous objects.
	 */
	function merge(rest_objects) {
		var result = {};
		each(arguments, function(object) {
			for (var k in object)
				if (object.hasOwnProperty(k))
					result[k] = object[k];
		});
		return result;
	}

	/*
	 * If name already exists in object, does nothing; otherwise
	 * inserts the given name-value pair into object.
	 */
	function put_new(object, name, value) {
		if (object.hasOwnProperty(name))
			return;
		object[name] = value;
	}

	/*
	 * Walks the document tree in document order and applies func
	 * to each element.
	 */
	function walk(tree, func) {
		func(tree);
		each(tree.children, function(child) {
			walk(child, func)
		});
	}

	/*
	 * Finds all elements matching predicate pred in document
	 * tree.  Elements are returned in document order.
	 */
	function find(tree, pred) {
		var result = [];
		walk(tree, function(element) {
			if (pred(element))
				result.push(element);
		});
		return result;
	}

	/*
	 * Inserts a deep clone of node before node.
	 */
	function dup(node) {
		return node.parentNode.insertBefore(node.cloneNode(true), node);
	}

	/*
	 * Returns true if element has a data-source attribute;
	 * otherwise returns false.
	 */
	function has_data_source(element) {
		return element.dataset && element.dataset.hasOwnProperty('source');
	}

	/*
	 * Fully decodes url parameter.  Taken from the mozilla wiki.
	 */
	function url_decode(parameter) {
		return decodeURIComponent(parameter.replace(/\+/g, ' '));
	}

	/*
	 * Decodes the given url query string.  Returns the result as
	 * an object.  If a query parameter occures more than once,
	 * the first occurence is used.
	 */
	function url_decode_query(query) {

		var result = {};

		if (query.charAt(0) == '?')
			query = query.substring(1);

		each(query.split('&'), function(name_value_pair) {
			var parts = name_value_pair.split('=', 2);
			var name = url_decode(parts[0]);
			var value = url_decode(parts[1] || '');
			if (name != '')
				put_new(result, name, value);
		});

		return result;
	}

	/*
	 * Issues an xhr http request and calls func with the
	 * resulting json object. If the http status code is
	 * not 200, calls error_handler and returns.
	 */
	function get_json(uri, func) {
		var xhr = new XMLHttpRequest();
		xhr.open('GET', uri);
		xhr.onload = function() {
			if (xhr.status != 200) {

				if (typeof error_handler == 'function')
					error_handler(xhr);

				if (typeof error_handler == 'string')
					location = error_handler;

				return;
			}
			func(JSON.parse(xhr.responseText));
		}
		xhr.send(null);
	}

	/*
	 * Substitutes occurences of {name} with
	 * encodeURIComponent(data[name]) in string.
	 * Returns the resulting string or null if no
	 * substitutions were made.
	 */
	function uri_template(string, data) {

		var subst = false;

		var result = string.replace(/{(.+?)}/g, function(_, name) {

			if (!data.hasOwnProperty(name))
				return '';

			subst = true;

			return encodeURIComponent(data[name]);
		});

		if (!subst)
			return null;

		return result;

	}

	function fill(element, data) {
		if (element.dataset)
			element.dataset['json'] = JSON.stringify(data);
		walk(element, function(element) {
			for (var k in element.dataset) {

				if (k == 'source')
					continue;

				if (k == 'json')
					continue;


				if (data.hasOwnProperty(element.dataset[k])) {
					element[k] = data[element.dataset[k]];
					delete element.dataset[k]
					continue;
				}

				var result = uri_template(element.dataset[k], data);

				if (result == null)
					continue;

				element[k] = result;
				delete element.dataset[k]
			}
		});
	}

	function source_uri(string, data) {

		if (data.hasOwnProperty(string))
			return data[string];

		var result = uri_template(string, data);

		if (result != null)
			return result;

		if (string.indexOf('?') != -1)
			return string;

		return string + location.search;
	}

	var stack = find(root, has_data_source);
	var query = url_decode_query(location.search);
	put_new(query, 'location', location);
	function process_next_source_element() {
		if (stack.length == 0) {
			/*
			 * Do a last pass over the root element to
			 * fill elements without a data-source parent.
			 */
			fill(root, query)
			if (done_callback)
				done_callback();
			return;
		}
		var element = stack.pop();
		var uri = source_uri(element.dataset['source'], query);
		delete element.dataset['source'];
		get_json(uri, function(json) {
			each(json, function(data) {
				fill(dup(element), merge(query, data));
			});
			element.parentNode.removeChild(element);
			process_next_source_element();
		});

	}

	process_next_source_element();

}

window['autofill'] = autofill;
