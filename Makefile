# Farhan Bin Faisal, Dec 2024

# This driver script processes text from four novels:
# - A Journey to the Western Islands of Scotland
# - The People of the Abyss
# - Scott’s Last Expedition:
# - My First Summer in the Sierra
#
# Subsequently, the script analyzes their most frequently occurring words, 
# and generates figures displaying the top 10 words for each novel.

# example usage:
# make all

SCR_W = scripts/wordcount.py
SCR_P = scripts/plotcount.py

CMD_W = python $(SCR_W)
CMD_P = python $(SCR_P)

CMD_P = python scripts/plotcount.py
FIG_DIR = results/figure/

all: data figures report/count_report.html

## DATA
data: \
    results/isles.dat results/abyss.dat \
	results/last.dat results/sierra.dat

results/isles.dat: $(SCR_W) data/isles.txt
	$(CMD_W) --input_file=data/isles.txt --output_file=results/isles.dat

results/abyss.dat: $(SCR_W)  data/abyss.txt
	$(CMD_W) --input_file=data/abyss.txt --output_file=results/abyss.dat

results/last.dat: $(SCR_W)  data/last.txt
	$(CMD_W) --input_file=data/last.txt --output_file=results/last.dat

results/sierra.dat: $(SCR_W)  data/sierra.txt
	$(CMD_W) --input_file=data/sierra.txt --output_file=results/sierra.dat


## FIGURES

figures: \
    $(FIG_DIR)isles.png $(FIG_DIR)abyss.png \
	$(FIG_DIR)last.png $(FIG_DIR)sierra.png

results/figure/isles.png: $(SCR_P) results/isles.dat
	$(CMD_P) --input_file=results/isles.dat --output_file=$(FIG_DIR)isles.png

results/figure/abyss.png: $(SCR_P) results/abyss.dat
	$(CMD_P) --input_file=results/abyss.dat --output_file=$(FIG_DIR)abyss.png

results/figure/last.png: $(SCR_P) results/last.dat
	$(CMD_P) --input_file=results/last.dat --output_file=$(FIG_DIR)last.png

results/figure/sierra.png: $(SCR_P) results/sierra.dat
	$(CMD_P) --input_file=results/sierra.dat --output_file=$(FIG_DIR)sierra.png


## REPORT
report/count_report.html : report/count_report.qmd figures
	quarto render report/count_report.qmd
	quarto render report/count_report.qmd --to pdf

## CLEAN
clean-data :
	rm -f results/*.dat

clean-figures :
	rm -f $(FIG_DIR)*

clean : clean-data clean-figures
	rm -f report/count_report.html
	rm -f report/count_report.pdf
	rm -rf report/count_report_files

.PHONY: all data figures clean-data clean-figures clean