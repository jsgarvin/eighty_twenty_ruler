class Ruling
  PUSHOVER_URL = 'https://api.pushover.net/1/messages.json'

  def call
    return if last_run_doc.nil?
    HTTP.post(PUSHOVER_URL, params: pushover_payload)
  end

  private

  def pushover_payload
    {
      token: EightyTwentyRuler.config.pushover_token,
      user: EightyTwentyRuler.config.pushover_user_key,
      message: full_summary,
      title: "80/20 Ruler Update",
      sound: 'bike',
    }
  end

  def full_summary
    <<MSG
Lactate Threshold Set To: #{EightyTwentyRuler.config.lactate_threshold} BPM

Last Run (#{run_at(last_run_doc).localtime.strftime('%A, %B %e %H:%M')})
--------
#{IntensitySummary.new(last_run_doc)}

One Week Trailing Average
---------------------------
#{IntensitySummary.new(xml_docs(1.week.ago))}

Three Week Trailing Average
---------------------------
#{IntensitySummary.new(xml_docs(3.weeks.ago))}
MSG
  end

  def last_run_doc
    xml_docs(3.weeks.ago).last
  end

  def xml_docs(since)
    Dir.glob("#{EightyTwentyRuler.config.folder}/*Run*.tcx")
      .select {|f| File.mtime(f) > since.beginning_of_day }
      .map { |path| File.open(path) { |f| Nokogiri::XML(f) } }
      .select { |doc| run_at(doc) > since.beginning_of_day }
      .sort { |a, b| run_at(a) <=> run_at(b) }
  end

  def run_at(doc)
    Time.parse(doc.css('Trackpoint').first.css('Time').text)
  end
end
