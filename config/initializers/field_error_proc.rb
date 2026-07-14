# By default Rails wraps any field with a validation error in a
# <div class="field_with_errors">. Inside a flex row that div becomes the flex
# item in place of the input, so the input loses its `w-full` sizing and shrinks
# to its content width. We render the field untouched and surface errors
# ourselves (a message below the field), so return the tag as-is.
Rails.application.config.action_view.field_error_proc = ->(html_tag, _instance) { html_tag }
