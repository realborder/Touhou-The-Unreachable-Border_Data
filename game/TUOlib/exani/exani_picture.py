# -*- coding: utf-8 -*-

import os
from PIL import Image

#文件夹路径
DIR_PATH="exani_data"
#限制宽度
LIMIT_WIDTH=1024
#限制高度
LIMIT_HEIGHT=1024

#获取宽度
def GetWidth(name):
    tmp_img=Image.open(name)
    return (tmp_img.size)[0]

#生成图片        
def CreatePicture(image_list,side_length):
    if os.path.exists(os.path.join(os.path.dirname(image_list[0]),"_loadres.lua")):
        os.remove(os.path.join(os.path.dirname(image_list[0]),"_loadres.lua"))
    new_image = Image.new('RGBA', (side_length, side_length))
    curwidth=0
    curheight=0
    curbottom=0
    handle_flag=0
    fileobj=0
    over_image_list=[]
    print(len(image_list))
    
    path=os.path.join(os.path.dirname(image_list[0]),"_loadres.lua")
    fileobj=open(path,'a')
    exani=os.path.basename(os.path.dirname(image_list[0]))
    content="local _res = {\n"
    fileobj.write(content)
            
    for i in range(0,len(image_list)):
        tmp_img=Image.open(image_list[i])
        #如果图片大小超过限制
        if tmp_img.size[0]>=LIMIT_WIDTH or tmp_img.size[1]>=LIMIT_HEIGHT:
            over_image_list.append(os.path.basename(image_list[i]))
            continue
        if i==0:
            if tmp_img.size[0]>side_length or tmp_img.size[1]>side_length:
                return False
            curbottom=tmp_img.size[1]
        if curwidth+tmp_img.size[0]>side_length:
            if curbottom+tmp_img.size[1]>side_length:
                return False
            else:
                curwidth=0
                curheight=curbottom
                curbottom+=tmp_img.size[1]
        
        new_image.paste(tmp_img, (curwidth,curheight))
        handle_flag=1
        content="   {'"+os.path.basename(image_list[i])+"',{"+str(curwidth)+","+str(curheight)+","+str(tmp_img.size[0])+","+str(tmp_img.size[1])+"}},\n"
        fileobj.write(content)
        print('image:'+image_list[i])
        print(curwidth,curheight,tmp_img.size[0],tmp_img.size[1])
        curwidth+=tmp_img.size[0]
        if curbottom<(curheight+tmp_img.size[1]):
            curbottom=curheight+tmp_img.size[1]
        
    #new_image.show()
    if handle_flag==0:
        exani_path=os.path.dirname(image_list[0]) 
        print(exani_path+": all image's size is out of limit")
    else:
        exani=os.path.basename(os.path.dirname(image_list[0]))
        content=os.path.join(os.path.dirname(image_list[0]),exani+"_res.png")
        print('save image:',content)
        new_image.save(content)
    
    if over_image_list:
        for image in over_image_list:
            name,ext=os.path.splitext(image)
            content="   '"+image+"',\n"
            fileobj.write(content)
            
    fileobj.write("}\nreturn _res\n")
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
        if os.path.exists(os.path.join(os.path.dirname(image_list[0]),"_loadres.lua")):
            os.remove(os.path.join(os.path.dirname(image_list[0]),"_loadres.lua"))
        print('too big')
        path=os.path.join(os.path.dirname(image_list[0]),"_loadres.lua")
        fileobj=open(path,'a')
        content="local _res = {\n"
        fileobj.write(content)
        for i in range(0,len(image_list)):
            image=os.path.basename(image_list[i])
            content="   '"+image+"',\n"
            fileobj.write(content)
        fileobj.write("}\nreturn _res\n")


#子文件夹列表
directorty_list=[]
#获取子文件夹
node_list = os.listdir(DIR_PATH)
for node in node_list:
    path = os.path.join(DIR_PATH,node)
    if os.path.isdir(path):
        directorty_list.append(node)

for directory in directorty_list:
    print(directory)

for exani in directorty_list:
    path=os.path.join(DIR_PATH,exani)
    if os.path.exists(os.path.join(path,exani+"_res.png")):
        os.remove(os.path.join(path,exani+"_res.png"))
    image_list=[]
    for filename in os.listdir(path):
        if filename.endswith('png'):
            image_list.append(os.path.join(path,filename))
    if image_list:
        ImageCompos(image_list)
    else:
        print("exani",exani,"not has image")
