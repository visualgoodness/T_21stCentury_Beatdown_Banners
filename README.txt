

21st Century Competitive Beatdown Banner

Specs: http://frontpage.solutions.yahoo.com/interactive.html

Git: git@github.com:visualgoodness/T_21stCentury_Beatdown_Banners.git

Libs: GreenSock: http://www.greensock.com/v11/
      VGFrameWork: git@github.com:visualgoodness/VGFramework.git

Previous deliveries: http://sandbox.vgstaging.com/dwh/00001/20110701/   (dwh / mwr7k7)

Assets: /work/DonatWald+Haque/C1614-00001 21st Century WC Banners/Client Supplied
	(same path for work drive and also FTP while moving -- 209.114.44.190 / vgftptemp / L4Py[9.t)


OVERVIEW:
The source files are organized and pretty straightforward.  Make sure you have Greensock Tweening Platform v11 in the src directory.

POSSIBLE UPDATES:
Any changes to the scoring logic happens on ScoreKeeper.as.  Here you can adjust number of hits to play a reaction, number of hits to unlock cheap shot, and number of hits to complete the game.  Instances of ScoreKeeper are passed around to various other instances in a subject-observer relationship so that changes in ScoreKeeper data can send events to whoever needs to receive them.

Joey's video reactions are FLV video assets embedded in the timeline inside the symbol "bag_2".  If changes need to be made to the reactions or if more reactions will be added, embed them in the timeline and adjust the bag tracking.  ScoreKeeper has a list of indices for each reaction and some logic that will beed to be updated as well if reactions are added or changed.

The panel text needs to be broken up in order to transform correctly during the fake-3D swinging animation.  There is a layer of broken text and then guide layers of editable text inside each symbol so that you can make the changes, copy the layer, and break it up again.