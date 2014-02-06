# todo: can we get rid of this already?
module Teaspoon::SpecHelper

  def javascript_include_tag_for_teaspoon(*sources)
    options = sources.extract_options!
    sources.collect do |source|
      asset = defined?(lookup_asset_for_path) ? lookup_asset_for_path(source, type: :javascript) : asset_paths.asset_for(source, "js")
      if asset.respond_to?(:logical_path)
        asset.to_a.map do |dep|
          javascript_include_tag(dep.pathname.to_s, src: asset_src(dep, options[:instrument]), type: "text/javascript").split("\n")
        end
      else
        javascript_include_tag(source) unless source.blank?
      end
    end.flatten.uniq.join("\n").html_safe
  end

  def asset_src(dep, instrument = false)
    params = "?body=1"
    params << "&instrument=1" if instrument && @suite && @suite.instrument_file?(dep.pathname.to_s)

    "#{Rails.application.config.assets.prefix}/#{dep.logical_path}#{params}"
    #"#{Teaspoon.configuration.context}#{Rails.application.config.assets.prefix}/#{dep.logical_path}#{params}"
  end
end
