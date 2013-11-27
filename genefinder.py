import sys
import re

class Gene:
  def __init__(self,start,end,strand,gi,COG,func):
    self.start=int(start)
    self.end=int(end)
    self.strand=strand
    self.gi=gi
    self.COG=COG
    self.func=func
  def length(self):
    return self.end-self.start+1

def readPtt(infile):
  ifh=open(infile,'r')
  genes=[]
  for i in range(3):
    disLine=ifh.readline()
  while 1:
    line=ifh.readline().rstrip('\n')
    if not line:
      break
    col=line.split('\t')
    (start,end)=re.search('(\d+)\.\.(\d+)',col[0]).group(1,2)
    strand=col[1]
    gi=col[3]
    COG=col[-2]
    func=col[-1].replace(' ','_',col[-1].count(' '))
    genes.append(Gene(start,end,strand,gi,COG,func))
  ifh.close()
  return genes
  
def findGene(startIndex,endIndex,start,end):
	lower=0
	upper=max(endIndex.keys())
	i=lower
	j=endIndex[upper]
	while start>lower:
		if start in startIndex:
			i=startIndex[start]
			break
		elif start in endIndex:
			i=endIndex[start]+1
			break
		else:
			start-=1
	while end<upper:
		if end in endIndex:
			j=endIndex[end]
			break
		elif end in startIndex:
			j=startIndex[end]-1
			break
		else:
			end+=1
	return i,j
		
def main():
	ifh=open(sys.argv[1],'r')
	ptt=sys.argv[2]
	ofh=open(sys.argv[3],'w')
	thr=int(sys.argv[4])
	Genes=readPtt(ptt)
	startIndex={}
	endIndex={}
	for index in range(len(Genes)):
		startIndex[Genes[index].start]=index
		endIndex[Genes[index].end]=index
	
	while 1:
		tag=ifh.readline().rstrip('\n')
		if not tag:
			break
		seq=ifh.readline().rstrip('\n')
		start,segLen,tip=re.search('start(\d+)\.seg\_len(\d+)\#0\/(\d{1})',tag).group(1,2,3)
		start=int(start)
		segLen=int(segLen)
		readLen=len(seq)
		if tip=='1':
			end=start+readLen-1
		elif tip=='2':
			end=start+segLen-1
			start=start+segLen-readLen-1
		Indices=findGene(startIndex,endIndex,start,end)
		GIs=[]

#		print start,end,'-------',str(Genes[Indices[0]].start)+'..'+str(Genes[Indices[0]].end),str(Genes[Indices[1]].start)+'..'+str(Genes[Indices[1]].end)
		for i in range(Indices[0],Indices[1]+1):
			coors=sorted([Genes[i].start,Genes[i].end,start,end])
			x=coors.index(start)
			y=coors.index(end)
			
			overlap=0 
			
			if (x==0 and y==1) or (x==2 and y==3):
				overlap=0
			elif x==1 and y==2:
				overlap=readLen
			else:
				overlap=coors[2]-coors[1]+1
			
			if overlap>=thr:
				if overlap>110:
					print overlap,thr,Genes[i].start,Genes[i].end,start,end
				GIs.append(Genes[i].gi+'/'+Genes[i].COG+'/'+Genes[i].func+'/'+str(overlap))
				
		tag=tag.replace('seg_len'+str(segLen),'seg_len'+str(segLen)+'.GIs['+','.join(GIs)+']')
		ofh.write(tag+'\n'+seq+'\n')
	ifh.close()
	ofh.close()
	
if __name__=="__main__":
	main()