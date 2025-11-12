class DateTags < SiteBuilder
  def build
    # Cache Date.today to avoid multiple system calls
    today = Date.today

    liquid_tag :year_now do
      today.year.to_s
    end

    liquid_tag :website_version do
      "v.#{today.year}.#{two_digit today.month}"
    end

    liquid_tag :updated_on do
      today.strftime("%B %d, %Y")
    end
  end

  private

  def two_digit number
    sprintf("%02d", number)
  end
end
