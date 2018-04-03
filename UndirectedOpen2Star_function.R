UndirectedOpen2Star<-function(NET){
  sub<-make_graph( ~ 1-3-2)
  NET<-igraph::simplify(NET)
  H<-igraph::subgraph_isomorphisms(sub, NET)
  EL<-list()
  for (i in 1:length(H)){
    R<-H[[i]]
    R2<-as.vector(R)
    EL[[i]]<-R2
  }
  EL2<-do.call(rbind.data.frame, EL)
  colnames(EL2)<-c("1","2","3")

  ISO<-list()
  for (i in 1:length(EL)){
    VEC<-EL[[i]]
    subCheck<-igraph::induced_subgraph(NET, VEC)
    ISO[[i]]<-igraph::ecount(subCheck)
  }
  DFedges<-plyr::ldply(ISO,data.frame)
  colnames(DFedges)<-"Number of Edges"
  DATA<-cbind(EL2,DFedges)

  dat<-DATA
  dat.sort<-t(apply(dat, 1, sort))
  DATA2<- dat[!duplicated(dat.sort),]

  DATA2<-DATA2[DATA2$`Number of Edges` == 2,]

  V(NET)$id<-1:length(V(NET)$name)
  Vert<-igraph::get.data.frame(NET, what = "vertices")

  DATA2$`1`<-Vert$name[match(DATA2$`1`,Vert$id)]
  DATA2$`2`<-Vert$name[match(DATA2$`2`,Vert$id)]
  DATA2$`3`<-Vert$name[match(DATA2$`3`,Vert$id)]
  colnames(DATA2)<-c("Alter1","Alter2","Ego","No.Ties")
  return(DATA2)
}
