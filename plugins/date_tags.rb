class DateTags < SiteBuilder
  def build
    liquid_tag :year_now do
      "#{Date.today.year}"
    end

    liquid_tag :website_version do
      "v.#{Date.today.year}.#{two_digit Date.today.month}"
    end
  end

  private

  def two_digit number
    sprintf("%02d", number)
  end
end
