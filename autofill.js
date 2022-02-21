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

	function dup(element) {
		return element.parentNode.insertBefore(element.cloneNode(true), element);
	}

	function has_data_source(element) {
		return element.dataset && element.dataset['source'];
	}

	function has_data_json(element) {
		return element.dataset && element.dataset['json'];
	}

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
	 * encodueURIComponent(data[name]) in string.
	 * Returns the resulting string or null if no
	 * substitutions happend.
	 */
	function uri_template(string, data) {

		var subst = false;

		var result = string.replace(/{(.+?)}/g, function(_, name) {

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
	}

	var stack = find(root, has_data_source);

	function process_next_source_element() {

		if (stack.length == 0) {
			if (done_callback)
				done_callback();
			return;
		}
		var element = stack.pop();
		var uri = element.dataset['source'] + location.search;
		delete element.dataset['source'];
		get_json(uri, function(json) {
			each(json, function(data) {
				var newElement = dup(element);
				newElement.dataset['json'] = JSON.stringify(data);
				walk(newElement, function(element) {
					fill(element, data);
				});
			});
			element.parentNode.removeChild(element);

			process_next_source_element();
		});

	}

	process_next_source_element();

}

window['autofill'] = autofill;
