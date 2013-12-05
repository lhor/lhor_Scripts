library(ggplot2)

dat<-read.table('c.sorted.f.filt.i97.a70.em10.all.Urbana.gg_97.blastn.tab', sep="\t", h=F)

# Add addition columns, needed for drawing with geom_rect.
top.n = 10
dat$fraction = dat$V2 / sum(dat$V2)
dat = dat[order(dat$fraction, decreasing=TRUE), ]
if(nrow(dat)>top.n) dat = rbind(data.frame(dat[1:top.n, ]), data.frame(V1=paste('Other (',nrow(dat)-top.n,')',sep=''), V2=sum(dat[(top.n+1):nrow(dat), 2]), fraction=sum(dat[(top.n+1):nrow(dat),3])));
dat$ymax = cumsum(dat$fraction)
dat$ymin = c(0, head(dat$ymax, n=-1))


ggplot(dat, aes(fill=dat$V1, ymax=ymax, ymin=ymin, xmax=4, xmin=3)) +
     geom_rect(colour="grey30") +
     coord_polar(theta="y") +
     xlim(c(0, 4)) +
     theme_bw() +
     theme(panel.grid=element_blank()) +
     theme(axis.text=element_blank()) +
     theme(axis.ticks=element_blank()) +
     labs(title="Customized ring plot")
