#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'rubygems/package'
require 'zlib'
module Katello
class PuppetModule
  include Glue::Pulp::PuppetModule if Katello.config.use_pulp
  include Glue::ElasticSearch::PuppetModule if Katello.config.use_elasticsearch
  CONTENT_TYPE = "puppet_module"

  def self.parse_metadata(filepath)
    metadata = nil

    tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(filepath))
    tar_extract.rewind # The extract has to be rewinded after every iteration
    tar_extract.each do |entry|
      next unless entry.file? && entry.full_name =~ %r{\A[^/]+/metadata.json\z}
      metadata = entry.read
    end

    if metadata
      return JSON.parse(metadata).with_indifferent_access
    else
      fail Katello::Errors::InvalidPuppetModuleError, _("Invalid puppet module. Please make sure the puppet module contains a metadata.json file and is properly compressed.")
    end
  rescue Zlib::GzipFile::Error, Gem::Package::TarInvalidError
    raise Katello::Errors::InvalidPuppetModuleError, _("Could not unarchive puppet module. Please make sure the puppet module has been compressed properly.")
  ensure
    tar_extract.close if tar_extract
  end
end
end
