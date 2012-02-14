namespace :test do
  task create_clips: :environment do
    Word.unclipped.each do |w|
      Clip.create(word_id: w.id, status: 0) if rand > 0.2
      puts "created #{w.entry}"
    end
  end
end

