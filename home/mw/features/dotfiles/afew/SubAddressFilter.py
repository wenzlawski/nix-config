from afew.filters.BaseFilter import Filter
from afew.FilterRegistry import register_filter
import re

@register_filter
class SubAddressFilter(Filter):
    message = 'Create a tag based on the subaddress'

    def handle_message(self, message):
        mail = message.get_header('To')
        matches = re.search(r'(?<=\+)[^@]+', mail)
        if matches:
            self.add_tags(message, "sub", "_" + matches.group(0))
