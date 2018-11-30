class IntensitySummary
  attr_reader :run_docs

  def initialize(run_docs)
    @run_docs = [run_docs].flatten
  end

  def to_s
    <<MSG
#{ percent_in(:low) } Low Intensity (<#{moderate_intensity_threshold_bpm} BPM)
#{ percent_in(:moderate) } Moderate Intensity
#{ percent_in(:high) } High Intensity (>#{high_intensity_threshold_bpm} BPM)
MSG
  end

  private

  def percent_in(zone)
    sprintf('%3d%', total_time_per_zone[zone]/total_time*100)
  end

  def total_time
    @total_time ||= total_time_per_zone.values.reduce(:+)
  end

  def total_time_per_zone
    @zone_totals ||= Hash.new(0.0).tap do |totals|
      run_docs.map do |doc|
        doc.css('Trackpoint')
           .each_cons(2)
           .map { |trackpoints| datapoint_hash(*trackpoints) }
           .each do |datapoint|
             case datapoint[:bpm]
             when 0...moderate_intensity_threshold_bpm then
               totals[:low] += datapoint[:time]
             when moderate_intensity_threshold_bpm...high_intensity_threshold_bpm then
               totals[:moderate] += datapoint[:time]
             else
               totals[:high] += datapoint[:time]
             end
           end
      end
    end
  end

  def datapoint_hash(*trackpoints)
    {
      time: seconds_between(*trackpoints),
      bpm: trackpoints[1].css('HeartRateBpm/Value').text.to_i
    }
  end

  def seconds_between(*trackpoints)
    Time.parse(trackpoints[1].css('Time').text) -
      Time.parse(trackpoints[0].css('Time').text)
  end

  def moderate_intensity_threshold_bpm
    (EightyTwentyRuler.config.lactate_threshold * 0.91).ceil
  end

  def high_intensity_threshold_bpm
    (EightyTwentyRuler.config.lactate_threshold * 0.93).ceil
  end
end
