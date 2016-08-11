
require 'terminal-table'

class ConceptAIScreenFormatter

  def initialize(concepts_ai)
    @concepts_ai = concepts_ai
  end

  def export
	  project=Project.instance
    return if project.show_mode==:none

    project.verbose "\n[INFO] Showing concept stats...\n"
    total_q=total_e=total_c=0
    total_sa=total_sb=total_sc=total_sd=total_se=total_si=0

    my_screen_table = Terminal::Table.new do |st|
      st << ['Concept','Questions','Entries','xFactor','a','b','c','d','e','i']
      st << :separator
    end

    @concepts_ai.each do |concept_ai|
      if concept_ai.process?
        e = concept_ai.texts.size
        concept_ai.tables.each { |t| e = e+t.data[:fields].size*t.data[:rows].size }

        sa = concept_ai.questions[:stage_a].size
        sb = concept_ai.questions[:stage_b].size
        sc = concept_ai.questions[:stage_c].size
        sd = concept_ai.questions[:stage_d].size
        se = concept_ai.questions[:stage_e].size
        si = concept_ai.questions[:stage_i].size
        t = sa+sb+sc+sd+se+si

        if e==0 then
          factor="Unkown"
        else
          factor=(t.to_f/e.to_f).round(2).to_s
        end
        my_screen_table.add_row [Rainbow(concept_ai.name).color(:green), t, e, factor, sa, sb, sc, sd, se, si]

        total_q+=t; total_e+=e; total_c+=1
        total_sa+=sa; total_sb+=sb; total_sc+=sc; total_sd+=sd; total_se+=se; total_si+=si
      end
    end

    my_screen_table.add_separator
    my_screen_table.add_row [ Rainbow("TOTAL = #{total_c.to_s}").bright,Rainbow(total_q.to_s).bright,Rainbow(total_e.to_s).bright,Rainbow((total_q.to_f/total_e.to_f).round(2)).bright, total_sa, total_sb, total_sc, total_sd, total_se, total_si ]
    project.verbose my_screen_table.to_s+"\n"
  end

end
