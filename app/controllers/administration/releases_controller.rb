module Administration
  class ReleasesController < Administration::ApplicationController
    protected

    def resource_params
      super.tap do |parameters|
        parameters.merge!(
          logs: JSON.parse(parameters[:logs].gsub("=>", ":"))
        ) if parameters[:logs].present?
      end
    end
  end
end
