# frozen_string_literal: true

require 'dry/system'

Dry::System.register_provider(:snowpack, boot_path: Pathname(__dir__).join('components').realpath)
