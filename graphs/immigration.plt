#set terminal eps enhanced size 1000 1000 fname "Times" fsize 36
set term postscript eps color blacktext "Helvetica" 24
set boxwidth 0.9 absolute
set style fill   solid 1.00 border -1
set style histogram clustered gap 1 title  offset character 0, 0, 0
set datafile missing '-'
set style data histograms
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 
set xtics   ("1891-1900" 0.00000, "1901-1910" 1.00000, "1911-1920" 2.00000, "1921-1930" 3.00000, "1931-1940" 4.00000, "1941-1950" 5.00000, "1951-1960" 6.00000, "1961-1970" 7.00000)
set title "US immigration from Northern Europe\nPlot selected data columns as histogram of clustered boxes" 
set yrange [ 0.00000 : 300000. ] noreverse nowriteback
plot 'immigration.dat' using 6:xtic(1) ti col, '' u 12 ti col, '' u 13 ti col, '' u 14 ti col
