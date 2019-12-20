import os
from PIL import Image

def GetWidth(name):
    tmp_img=Image.open(name)
    return (tmp_img.size)[0]
        
def CreatePicture(image_list,side_length):
    new_image = Image.new('RGBA', (side_length, side_length))
    curwidth=0
    curheight=0
    curbottom=0
    print(len(image_list))
    for i in range(0,len(image_list)):
        tmp_img=Image.open(image_list[i])
        if i==0:
            if tmp_img.size[0]>side_length or tmp_img.size[1]>side_length:
                print('false')
                return False
            curbottom=tmp_img.size[1]
        if curwidth+tmp_img.size[0]>side_length:
            if curbottom+tmp_img.size[1]>side_length:
                print('false')
                return False
            else:
                curwidth=0
                curheight=curbottom
                curbottom+=tmp_img.size[1]
        
        new_image.paste(tmp_img, (curwidth,curheight))
        print('image:'+image_list[i])
        print(curwidth,curheight,tmp_img.size[0],tmp_img.size[1])
        curwidth+=tmp_img.size[0]
        
    new_image.show()
    new_image.save('new_image.png')
    print('true')
    return True
        
        
def ImageCompos(image_list):
    
    image_list.sort(key=GetWidth,reverse=True)
    
    if CreatePicture(image_list,256):
        print(256)
    elif CreatePicture(image_list,512):
        print(512)
    elif CreatePicture(image_list,1024):
        print(1024)
    elif CreatePicture(image_list,2048):
        print(2048)
    else:
        print('too big')

all_path=[]
for filename in os.listdir('./'):
    if filename.endswith('jpg') or filename.endswith('png'):
        all_path.append(os.path.join('./', filename))
ImageCompos(all_path)
