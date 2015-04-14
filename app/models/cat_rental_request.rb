class CatRentalRequest < ActiveRecord::Base
  validates :status, presence: true, inclusion: %w(PENDING APPROVED DENIED)
  validates :cat_id, presence: true

  after_initialize { self.status ||= "PENDING" }

  validate :overlapping_approved_requests

  belongs_to :cat

  def approve!
    self.status = "APPROVED" if self.status == "PENDING"
    CatRentalRequest.transaction do
      self.save!
      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    self.status = "DENIED" if self.status == "PENDING"
    self.save!
  end

  def pending?
    return true if self.status == "PENDING"
    false
  end
  private
    def overlapping_requests
      CatRentalRequest.find_by_sql(["
        SELECT
          cat_rental_requests.*
        FROM
          cat_rental_requests
        JOIN
          cats ON cat_id = cats.id
        WHERE
          cats.id = ?
          AND
          NOT( ? > end_date OR ? < start_date)
          AND
          status = 'APPROVED'
        ", self.cat_id, self.start_date, self.end_date])
    end

    def overlapping_approved_requests
      return nil if self.status == "DENIED"
      overlapping_requests.each do |request|
        errors.add(:cat_id, "has a conflict") if request.id != self.id
      end
    end

    def overlapping_pending_requests
      CatRentalRequest.find_by_sql(["
        SELECT
          cat_rental_requests.*
        FROM
          cat_rental_requests
        JOIN
          cats ON cat_id = cats.id
        WHERE
          cats.id = ?
          AND
          NOT( ? > end_date OR ? < start_date)
          AND
          status = 'PENDING'
        ", self.cat_id, self.start_date, self.end_date])
    end
end
