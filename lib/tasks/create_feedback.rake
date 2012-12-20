desc "Splits the original feedback for each section into its own model"
task :create_feedback => :environment do
  Bundler.require(:progressbar)
  progressbar = ProgressBar.create(:format => '%t |%b>%i| %p%% %a', :title => "Progress", :total => Section.count)
  Feedback.delete_all
  Section.all.each do |s|
    next if s.feedback.nil?
    feedbacks = s.feedback.split('/')
    feedbacks.each do |f|
      Feedback.create(feedback: f, section_id: s.id)
    end
    progressbar.progress += 1
  end
end