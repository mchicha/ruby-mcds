module PaginationMetadata
  extend ActiveSupport::Concern

  private

    def paginate_meta(object=[])
      {
        current_page: object.try(:current_page),
        next_page: object.try(:next_page),
        prev_page: object.try(:prev_page),
        total_pages: object.try(:total_pages),
        total_count: object.try(:total_count)
      }
    end

end
