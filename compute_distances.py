from PIL import Image
import imagehash
import glob
import numpy as np
import pandas as pd


indir = 'images'
hash_dict={}
for filepath in glob.iglob(indir + "/*.png"):
    print(filepath)
    hash = imagehash.phash(Image.open(filepath))
    hash_dict[filepath] = hash
np.save('data/hash_dict.npy',hash_dict)

hash_dict = np.load('data/hash_dict.npy').item()
dist=pd.DataFrame(columns=['main_file','comp_file','distance'])
for main_file,main_hash in hash_dict.iteritems():
    print main_file
    for comp_file,comp_hash in hash_dict.iteritems():
        distance=main_hash-comp_hash
        newdist = pd.DataFrame([[main_file, comp_file, distance]], columns=['main_file', 'comp_file', 'distance'])
        dist=dist.append(newdist, ignore_index=True)

dist.to_csv('data/distances.csv',index=False,encoding='utf-8')
