#Backup our home directory to all backup drives 1,2,3

rsync -av /home/rflagg/ /mnt/backup1/rflagg
rsync -av /home/rflagg/ /mnt/backup2/rflagg
rsync -av /home/rflagg/ /mnt/backup3/rflagg


#Sync our main folders to the remote desktop sync
rsync -av -e ssh /home/rflagg/Documents/ rflagg@fafnir:/data/Desktop-Sync/Documents/
rsync -av -e ssh /home/rflagg/Pictures/ rflagg@fafnir:/data/Desktop-Sync/Pictures/  
rsync -av -e ssh /home/rflagg/Videos/ rflagg@fafnir:/data/Desktop-Sync/Videos/    
rsync -av -e ssh /home/rflagg/scripts/ rflagg@fafnir:/data/Desktop-Sync/scripts 

rsync -av -e ssh /home/rflagg/Documents/ rflagg@fafnir:/vault/Desktop-Sync/Documents/
rsync -av -e ssh /home/rflagg/Pictures/ rflagg@fafnir:/vault/Desktop-Sync/Pictures/
rsync -av -e ssh /home/rflagg/Videos/ rflagg@fafnir:/vault/Desktop-Sync/Videos/
rsync -av -e ssh /home/rflagg/scripts/ rflagg@fafnir:/vault/Desktop-Sync/scripts

date >> ~/backup.log
