class DocumentSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :display_name,
              :sort_order,
              :height,
              :width,
              :type,
              :filename,
              :background,
              :type_of,
              :zone,
              :print_scale,
              :programs

  has_many    :elements, serializer: ElementSerializer, embed: :ids#, embed_in_root: true
  has_many    :notes, serializer: NoteSerializer

  def background
    "#{object.background}?#{object.digest}"
  end

  def programs
    ###############
    # The has_many's above are on the classitself, but the instances are what have the serialization_options.
    # Because programs need passed down scope to determine to include date_ranges or not, programs must be called
    # as an attribute then overriden here with the serialization_options passed in.
    # This was done for AMS 0.9. 0.10 can call blocks on associations which would alleviate much of this problem.
    #############

    ActiveModel::ArraySerializer.new(
      object.programs,
      each_serializer: ProgramSerializer,
      scope: {
        original_scope: scope,
        inherited_serialization_options: serialization_options
      }
    )
  end
end
