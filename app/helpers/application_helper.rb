module ApplicationHelper
  # Tailwind CSS Styles

  def positive_button
    "text-white bg-violet-700 py-2 px-5 rounded hover:bg-violet-900 shadow hover:shadow-lg h-10 active:bg-pink-700 "
  end

  def secondary_button
    "text-violet-700 dark:text-white bg-violet-50 dark:bg-violet-800 py-2 px-5 rounded hover:bg-violet-200 dark:hover:bg-violet-900 shadow hover:shadow-lg "
  end

  def light_button
    "text-violet-700 hover:text-violet-900 dark:text-violet-400 dark:hover:text-violet-300 py-2 "
  end

  def light_button_notice
    "text-violet-700 hover:text-violet-900 dark:white dark:hover:text-violet-300 py-2 "
  end

  def green_button
    "text-white bg-emerald-700 py-2 px-5 rounded hover:bg-emerald-900 shadow hover:shadow-lg "
  end

  def red_button
    "text-white bg-red-700 py-2 px-5 rounded hover:bg-red-900 shadow hover:shadow-lg "
  end

  def negative_button
    "text-white bg-violet-600 py-2 px-4 rounded hover:bg-white hover:text-violet-700 shadow hover:shadow-lg "
  end

  def negative_button_small
    "text-violet-200 hover:text-white"
  end

  def light_button_no_padding
    "text-violet-700 hover:text-violet-900 dark:text-violet-400 dark:hover:text-violet-300 "
  end

  def field
    "rounded bg-white dark:bg-gray-900 focus:bg-violet-100 dark:focus:bg-black focus:ring-1 focus:ring-violet-700 p-2 my-2 "
  end

  def dark_field
    "rounded bg-gray-50 dark:bg-gray-800 focus:bg-violet-100 dark:focus:bg-black focus:ring-1 focus:ring-violet-700 p-2 my-2 "
  end

  def cdn_static(filename)
    cdn_domain + "static/" + filename
  end

  def white_button
    "appearance-none py-2 px-5 text-violet-700 dark:text-gray-100 shadow hover:shadow-lg bg-white dark:bg-gray-800 hover:bg-violet-50 dark:hover:bg-violet-900 rounded "
  end

  def copy_button
    "text-violet-700 dark:text-violet-500 ml-1 text-xl hover:text-violet-900 dark:hover:text-violet-400 active:bg-yellow-100 dark:active:bg-yellow-900 rounded py-2 px-3"
  end

  def cdn_domain
    "https://d48ttl5m5edbw.cloudfront.net/"
  end

  def shape(participant_max_count)
    case participant_max_count
    when 2
      "dual"
    when 3
      "triangle"
    when 4
      "square"
    when 5
      "pentagon"
    else
      "N/A"
    end
  end

  def shape_image(swap_capacity_sats, participant_max_count, extension="jpg", dimension="full")
    # scope :small, -> { where(capacity: 0..999999) }
    # scope :medium, -> { where(capacity: 1000000..3000000) }
    # scope :large, -> { where(capacity: 3000001..1000000000) }
    case swap_capacity_sats
    when 0..999999
      size = "small"
    when 1000000..3000000
      size = "medium"
    when 3000001..1000000000
      size = "large"
    else
      size = ""
    end
    # 
    url = "#{cdn_static("neon-" + shape(participant_max_count) + "-" + size)}"
    url = (dimension == "card") ? (url + "-card.") : (url + ".")
    return (extension == "webp") ? (url + "webp") : (url + "jpg")
  end

  def status_color(status)
    case status
    when "pending"
      "violet-700"
    when "opening"
      "pink-700"
    when "completed"
      "emerald-700"
    else
      "gray-700"
    end
  end

  def humanize_swap_status(swap_status)
    case swap_status
    when "pending"
      "Open for Application"
    when "opening"
      "Opening Channels"
    when "completed"
      "Completed"
    else
      "Unknown Status"
    end
  end

  def humanize_seconds(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    "%d days, %d hrs. and %d mins." % [dd, hh, mm]
  end

  def satoshi_to_btc(satoshis)
    "~" + number_with_delimiter((satoshis.to_f/100000000).round(3), :delimiter => ',') + " BTC"
  end

  def formatted_satoshi(satoshis)
    number_with_delimiter(satoshis, delimiter: ',') + " SAT"
  end

  def humanize_capacity(satoshi)
    satoshi > 100000000 ? satoshi_to_btc(satoshi) : formatted_satoshi(satoshi)
  end

  def humanize_reputation(participant)
    if participant["lnplus_rank_number"] == nil
      ""
    else
      "Rank: " +
      participant["lnplus_rank_number"].to_s +
      " / " + 
      participant["lnplus_rank_name"] +
      " with " +
      participant["positive_ratings_count"].to_s + 
      " positive and " +
      participant["negative_ratings_count"].to_s +
      " negative ratings."
    end
  end

  def identifiers_array
    ["A","B","C","D","E"]
  end

  def identifiers(participant_max_count)
    identifiers_array[...participant_max_count]
  end

  def get_next_identifier(participant_identifier, participant_max_count)
    if identifiers_array[participant_max_count - 1] == participant_identifier
      "A"
    else
      identifiers_array[identifiers_array.find_index(participant_identifier) + 1]
    end
  end

  def previous_identifier(participant_identifier, participant_max_count)
    if participant_identifier == "A"
      identifiers_array[participant_max_count - 1]
    else
      identifiers_array[identifiers_array.find_index(participant_identifier) - 1]
    end
  end

  def find_participant(participants, identifier)
    participants.select{|p| p["participant_identifier"] == identifier}.first
  end

  def errors_present(json)
    json.is_a?(Hash) && json["errors"].present?
  end

end
