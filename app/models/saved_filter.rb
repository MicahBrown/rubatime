class SavedFilter < ApplicationRecord
  serialize :filters, Hash
end
