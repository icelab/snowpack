require_relative "./dummy/container"

Dummy::Container.require_from_root 'apps/web/system/boot'

Dummy::Container.finalize!
