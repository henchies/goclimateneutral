# frozen_string_literal: true

module Webpack
  module Helper
    def webpack_asset_path(source, options = {})
      compile_webpack if Webpack.config[:watch_changes]

      asset_path(
        public_path(Webpack.manifest.asset_hashed_path(source)),
        options.merge(skip_pipeline: true)
      )
    end

    def webpack_asset_url(source)
      webpack_asset_path(source, protocol: :request)
    end

    def webpack_entrypoint_javascript_tags(*entrypoints)
      options = entrypoints.last.is_a?(Hash) ? entrypoints.pop : {}

      compile_webpack if Webpack.config[:watch_changes]

      paths = Webpack.manifest.entrypoint_paths(entrypoints, 'js').map { |path| public_path(path) }
      javascript_include_tag(*paths, skip_pipeline: true, **options)
    end

    def webpack_entrypoint_stylesheet_tags(*entrypoints)
      compile_webpack if Webpack.config[:watch_changes]

      paths = Webpack.manifest.entrypoint_paths(entrypoints, 'css').map { |path| public_path(path) }
      stylesheet_link_tag(*paths, skip_pipeline: true)
    end

    private

    def compile_webpack
      Webpack.compiler.compile unless Webpack.dev_server_running?
    end

    def public_path(source)
      Pathname.new("/#{Webpack.config[:output_path]}").join(source)
    end
  end
end
