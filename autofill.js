function autofill(root, error_handler, done_callback) {

	function each(list, func) {
		for (var i = 0; i < list.length; i++)
			func(list[i]);
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

	function merge(rest_objects) {
		var result = {};
		each(arguments, function(object) {
			for (var k in object)
				if (object.hasOwnProperty(k))
					result[k] = object[k];
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
	function decodeQueryParam(p) {
		return decodeURIComponent(p.replace(/\+/g, ' '));
	}

	function params() {

		var result = {};

		if (location.search == null || location.search.length <= 1)
			return result;

		each(location.search.substring(1).split('&'), function(kv) {
			var parts = kv.split('=', 2);
			var name = decodeQueryParam(parts[0]);
			var value = decodeQueryParam(parts[1] || '');

			// do not overwrite properties
			if (result.hasOwnProperty(name))
				return;

			result[name] = value;
		});

		return result;
	}

	/*
	 * Issues an xhr http request and calls func with the
	 * resulting json object.
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
	 * substitutions happend.
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

	var stack = find(root, has_data_source);
	function process_next_source_element() {

		if (stack.length == 0) {
			if (done_callback)
				done_callback();
			return;
		}
		var element = stack.pop();

		if (element.dataset['source'] == 'params') {
			delete element.dataset['source'];
			fill(element, params());
			process_next_source_element();
			return;
		}

		var uri = element.dataset['source'] + location.search;
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
