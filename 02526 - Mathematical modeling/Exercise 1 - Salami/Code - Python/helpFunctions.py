
def loadMulti(imName, *args):
    # Loading multispectral image and an annotation
    # 
    # function [multiIm, annotationIm] = loadMulti(imName, annotationName)
    # 
    # Input
    #   imName - name of multispectral image file - a *.mat file
    #   annotationName - name of annotation image file - a *.png file
    #   dirPath (optional) - path to data directory where the image files are
    #       placed
    # 
    # Output
    #   multiIm - multispectral image
    #   annotationIm - image with annotation mask of size r x c x 3. Layer 1 is
    #       the salami annotation (both fat and meat, layer 2 is the fat, and
    #       layer 3 is the meat. The pixel value is 1 in the annotation and 0
    #       elsewhere.
    # 
    # Anders Nymark Christensen - DTU, 20180130
    # Adapted from
    # Anders Lindbjerg Dahl - DTU, January 2013
    # 
    
    import scipy.io as sio
    import numpy as np
    from scipy import misc
    
    annotationName = args[0] 
    if len(args) < 2:
        dirPath = ''
    else: 
        dirPath = args[1]
           
        
    # load the multispectral image
    im = sio.loadmat(dirPath+imName)
    multiIm = im['immulti']
        
    # make annotation image of zeros
    annotationIm = np.zeros([multiIm.shape[0],multiIm.shape[1],3],dtype=bool)
    
    # read the mask image
    aIm = misc.imread(dirPath+annotationName)
    
    # put in ones
    for i in range(0,3):
        annotationIm[:,:,i] = (aIm[:,:,i] == 255) 
    
    return (multiIm, annotationIm)









def getPix(multiIm, maskIm):
    # Extracting pixels from multispectral image
    # 
    # function [clPix, row, col] = getPix(multiIm, maskIm) 
    # 
    # Input
    #   multiIm - multispectral image of size r x c x l
    #   maskIm - binary mask with ones at pixels that should be extracted (use
    #       layers from annotationIm from the loadMulti function)
    # 
    # Output
    #   clPix - pixels in n x l matrix
    #   row - row pixels indicies
    #   col - column pixels indicies
    # 
    # Anders Nymark Christensen - DTU, 20180130
    # Adapted from
    # Anders Lindbjerg Dahl - DTU, January 2013
    # 
    
    import numpy as np
    nMask = maskIm.sum()
    
    r, c = np.where(maskIm == 1)
    
    clPix = np.zeros([nMask, multiIm.shape[2]])
    clPix = multiIm[r,c,:]    
    
    return [clPix, r, c]



def showHistograms(multiIm, pixId, *args):
    # Extracting a histogram from an 8 bit multispectral image (values ranging from 0
    # to 255)
    # 
    # function h = showHistograms(multiIm, pixId, band, showOn)
    # 
    # Input
    #   multiIm - multispectral image
    #   pixId - pixels that should be included in the histogram. Either a list of row
    #       and column indices of size n x 2, or a binary image of size r x c x m 
    #       with regions that should be part of the histogram. m is the number
    #       of histograms that should be extracted.
    #   band - spectral band where the histogram should be extracted
    #   showOn (optional) - boolean that tells if the histogram should be
    #       plotted. Default is not to plot the histogram. 
    # 
    # Output
    #   h - multispectral image
    # 
    # Anders Nymark Christensen - DTU, 20180130
    # Adapted from
    # Anders Lindbjerg Dahl - DTU, January 2013
    # 
    
    import numpy as np
    import matplotlib.pyplot as plt
    
    band = args[0]
    if len(args) < 2:
        showOn = 0
    else:
        showOn = args[1]
     
    
    
    
    if ( pixId.shape[0] == multiIm.shape[0] and pixId.shape[1] == multiIm.shape[1] ):
        n = pixId.shape[2]
        h = np.zeros([256,n])
        for i in range(0,n):
            for j in range(0,pixId.shape[0]):
                for k in range(0,pixId.shape[1]):
                    if pixId[j,k,i] == 1 :
                        h[multiIm[j,k,band]+1,i] = h[multiIm[j,k,band]+1,i] + 1

    else:
        h = np.zeros[256,1]
        for i in range(0,pixId.shape[0]):
            h[multiIm[pixId[i,0],pixId[i,1],band]+1] = h[multiIm[pixId[i,1],pixId[i,2],band]+1] + 1
    
    if showOn:
        hId = np.where(np.sum(h,1) > 0)
        fId = np.maximum(np.min(hId)-3,1)
        tId = np.minimum(np.max(hId)+3,255)
        for i in range(0,h.shape[1]):
            plt.plot(range(fId,tId),h[range(fId,tId),i])
        plt.show()
   
    return h







def  setImagePix(rgbIm, pixId):
    # Building a RGB image containing color pixels in regions and white
    #   elsewhere
    # 
    # function rgbOut = setImagePix(rgbIm, pixId) 
    # 
    # Input
    #   rgbIm - color image of size r x c x 3
    #   pixId - pixels that should contain color values. Either a list of row
    #       and column indices of size n x 2, or a binary image of size r x c 
    #       with regions that should contain color values.
    # 
    # Output
    #   rgbOut - output rgb image
    # 
    # Anders Nymark Christensen - DTU, 20180130
    # Adapted from
    # Anders Lindbjerg Dahl - DTU, January 2013
    # 
    
    import numpy as np
    
    rgbOut = rgbIm
    
    if ( pixId.shape[0] == rgbIm.shape[0] and pixId.shape[1] == rgbIm.shape[1] ):
        for i in range(0,rgbIm.shape[2]):
            rgbOut[:,:,i] = np.multiply(rgbIm[:,:,i],pixId) + 255*(1-pixId)
    
    else:
        rgbOut = rgbOut*0 + 255
        for i in range(0,pixId.shape[0]):
            rgbOut[pixId[i,0], pixId[i,1],:] = rgbIm[pixId[i,0], pixId[i,1],:]

    
    rgbOut = np.uint8(rgbOut)
    
    return rgbOut










