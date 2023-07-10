module Jekyll
    module DictFilter
        def dict(input, type)
            @objects = {}
            @config = @context.registers[:site].config["dict"]
            for obj in input
                if (!@objects.has_key?(obj.data["id"]))
                    @objects[obj.data["id"]] = {}
                end
                @object = @objects[obj.data["id"]]
                if (obj.data.has_key?("nested_fields"))
                    @nested_fields = obj.data["nested_fields"].split(".")
                    for nested_field in @nested_fields
                        if (!@object.has_key?(nested_field))
                            @object[nested_field] = {}
                        end
                        @object = @object[nested_field]
                    end
                end
                for key in @config[type]
                    @object[key] = obj.data[key]
                end
                @content = obj.to_s.gsub('\\"', '').gsub(/\n/, '').gsub(/\r/, '')
                if @content != ""
                    @object["content"] = @content
                end
            end
            return @objects
        end
    end
end

Liquid::Template.register_filter(Jekyll::DictFilter)