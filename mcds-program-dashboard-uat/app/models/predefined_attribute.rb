class PredefinedAttribute < ActiveRecord::Base
  serialize :values, JSON

  enum send_on: [:on_save, :on_create, :on_update]

  def assign_values(object)
    base_values = values['object_attrs']
    base_values.merge!({skip_predefined_attributes: true})

    object.update_attributes(base_values)


    association_values = values['associations'] || []

    association_values.each do |assoc|

      current_association = assoc['association']
      query_hash = {}
      query_hash[assoc['query_key']] = assoc['query_values']

      query = current_association.classify.constantize.where(query_hash)
      object.send("#{current_association}=", query)
    end
  end
end
