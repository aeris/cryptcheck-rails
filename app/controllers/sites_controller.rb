class SitesController < ApplicationController
  @@sites = YAML.load_file Rails.root.join 'config/sites.yml'
  @@sites.keys.each do |name|
    define_method(name) { sites name }
  end

  private

  def sites(name)
    @name = name
    @sites = Stat[:"sites_#{name}"].data
    render :sites
  end
end
