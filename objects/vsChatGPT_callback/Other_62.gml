/// @description Insert description here
// You can write your code in this editor

// Asynchronous HTTP Event in your chosen object
if (async_load[? "id"] == global.vsChatGPTID) {
    var status = async_load[? "status"];
    if (status == 0) {
        var result = async_load[? "result"];

		if (script_exists(global.vsChatGPTCallback)) {
			var json = json_decode(result);
			show_debug_message(result);
			show_debug_message(json_encode(json));

			var payload = ds_map_create();
				payload[? "id"] = json[? "id"];
				payload[? "model"] = json[? "model"];

			if (ds_map_exists(json, "choices")) {
				var choices = json[? "choices"];
				// If only 1 result, array is ignored
				if (ds_map_exists(choices, "content")) {
					payload[? "content"] = choices[? "content"];
				}
				else if (is_array(choices) && array_length_1d(choices) > 0) {
					var choice = choices[0];
					if (ds_map_exists(choice, "message")) {
					    var message = choice[? "message"];
					    if (ds_map_exists(message, "content")) {
					        payload[? "content"] = message[? "content"];
					    }
					}
				}
			}
			payload[? "usage"] = json[? "usage"];

	        script_execute(global.vsChatGPTCallback, payload);
			ds_map_destroy(json);
			ds_map_destroy(payload);
	    }
		// Process the result here
		else {
			show_debug_message(result);
		}
    }
	else {
        // Handle errors
        var errorMsg = "Error: " + string(status);
        show_debug_message(errorMsg);
    }
}
