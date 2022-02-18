function autofill(root, error_redirect) {

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

	function template(string, data) {
		var subst = false;
		var result = string.replace(/{(.+?)}/g, function(_, name) {
			if (!data.hasOwnProperty(name))
				return '';
			subst = true;
			return data[name];
		});
		return subst ? result : null;
	}

	function subst(string, data) {
		if (data.hasOwnProperty(string))
			return data[string];
		return template(string, data);

	}

	function has_data_source(element) {
		return element.dataset && element.dataset.source;
	}

	function has_data_json(element) {
		return element.dataset && element.dataset.json;
	}

	function fill(element, data) {
		for (var k in element.dataset) {
			if (k == 'source')
				continue;
			if (k == 'json')
				continue;
			var result = subst(element.dataset[k], data);
			if (result == null)
				continue;
			delete element.dataset[k];
			element[k] = result;
		}
	}

	function process_json_elements() {
		var stack = find(root, has_data_json);
		while (stack.length > 0) {
			var element = stack.pop();
			var json = JSON.parse(element.dataset.json);
			delete element.dataset.json;
			each(json, function(data) {
				var newElement = dup(element);
				newElement.dataset.json = JSON.stringify(data);
				walk(newElement, function(element) {
					fill(element, data);
				});
			});
			element.parentNode.removeChild(element);
		}
	}

	var stack = find(root, has_data_source);

	function process_next_source_element() {

		if (stack.length == 0) {
			process_json_elements();
			return;
		}

		var element = stack.pop();
		var uri = element.dataset.source + location.search;
		delete element.dataset.source;
		var xhr = new XMLHttpRequest();
		xhr.open('GET', uri);
		xhr.onload = function() {
			if (xhr.status != 200) {
				if (error_redirect)
					location = error_redirect;
				return;
			}
			element.dataset.json = xhr.responseText;
			process_next_source_element();
		}
		xhr.send(null);

	}

	process_next_source_element();

}

autofill(document, '/login');
