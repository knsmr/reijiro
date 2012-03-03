# -*- coding: utf-8 -*-
require 'eijiro'

e = EijiroDictionary.new(Reijiro::Application.config.dictionary_path)
e.convert_to_sql
e.write_to_database
e.write_level
e.import_acl_12000
