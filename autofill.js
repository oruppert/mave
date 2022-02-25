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
	 * inserts name-value pair into object.
	 */
	function putnew(object, name, value) {
		if (object.hasOwnProperty(name))
			return;
		object[name] = value;
	}


	function walk(element, func) {
		func(element);
		each(element.children, function(child) {
			walk(child, func)
		});
	}

	function find(element, pred) {
		var result = [];
		walk(element, function(element) {
			if (pred(element))
				result.push(element);
		});
		return result;
	}


	function dup(element) {
		return element.parentNode.insertBefore(element.cloneNode(true), element);
	}

	function has_data_source(element) {
		return element.dataset && element.dataset['source'];
	}

	// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent
	function decode(parameter) {
		return decodeURIComponent(parameter.replace(/\+/g, ' '));
	}

	function url_parameters() {
		var result = {};
		if (location.search != null || location.search.length > 1) {
			each(location.search.substring(1).split('&'), function(kv) {
				var parts = kv.split('=', 2);
				putnew(result, decode(parts[0]), decode(parts[1] || ''));
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

		if (subst)
			return result;

		return null;

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
			if (done_callback)
				done_callback();
			return;
		}
		var element = stack.pop();

		if (element.dataset['source'] == 'params') {
			delete element.dataset['source'];
			fill(element, params);
			process_next_source_element();
			return;
		}

		var uri = source_uri(element.dataset['source'], params);
		delete element.dataset['source'];
		get_json(uri, function(json) {
			each(json, function(data) {
				fill(dup(element), data);
			});
			element.parentNode.removeChild(element);
			process_next_source_element();
		});

	}

	process_next_source_element();

}

window['autofill'] = autofill;
