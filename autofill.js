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
	function putnew(object, name, value) {
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

	// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent
	function url_decode(parameter) {
		return decodeURIComponent(parameter.replace(/\+/g, ' '));
	}

	function url_parameters() {
		var result = {};
		if (location.search != null || location.search.length > 1) {
			each(location.search.substring(1).split('&'), function(kv) {
				var parts = kv.split('=', 2);
				putnew(result, url_decode(parts[0]), url_decode(parts[1] || ''));
			});
		}
		putnew(result, 'pathname', location['pathname']);
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

			if (name == 'location') {
				subst = true;
				return encodeURIComponent(location);
			}

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
		return string + location.search;
	}

	var stack = find(root, has_data_source);
	var params = url_parameters();
	function process_next_source_element() {
		if (stack.length == 0) {
			/*
			 * Do a last pass over the root element to
			 * fill elements without a data-source parent.
			 */
			fill(root, params)
			if (done_callback)
				done_callback();
			return;
		}
		var element = stack.pop();
		var uri = source_uri(element.dataset['source'], params);
		delete element.dataset['source'];
		get_json(uri, function(json) {
			each(json, function(data) {
				fill(dup(element), merge(params, data));
			});
			element.parentNode.removeChild(element);
			process_next_source_element();
		});

	}

	process_next_source_element();

}

window['autofill'] = autofill;
