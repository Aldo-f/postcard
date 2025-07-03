Rails::Html::WhiteListSanitizer.allowed_tags << "video"
Rails::Html::WhiteListSanitizer.allowed_tags << "source"

Rails::Html::WhiteListSanitizer.allowed_attributes << "controls"
Rails::Html::WhiteListSanitizer.allowed_attributes << "data-zoom-src"
Rails::Html::WhiteListSanitizer.allowed_attributes << "srcset"
Rails::Html::WhiteListSanitizer.allowed_attributes << "target"
