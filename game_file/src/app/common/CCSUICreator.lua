local CCSUICreator = class("CCSUICreator")
function CCSUICreator:generateUINode(cfgNode, parent)
	local clsName = cfgNode.classname
	local options = cfgNode.options
	options.x = options.x or 0
	options.y = options.y or 0
	local uiNode = self:createUINode(clsName, options, parent)
	if not uiNode then
		return
	end
	uiNode.name = options.name or "unknow node"
	uiNode:setName(options.name)
	local children = cfgNode.children
	if children then
		for i, v in ipairs(children) do
			local childrenNode = self:generateUINode(v, uiNode)
			if childrenNode then
				uiNode:addChild(childrenNode)
			end
		end
	end
	return uiNode
end
function CCSUICreator:createUINode(clsName, options, parent)
	if not clsName then
		return
	end
	local node
	if clsName == "Node" or clsName == "Layer" then
		node = self:createNode(options)
	elseif clsName == "Sprite" or clsName == "Scale9Sprite" then
		node = self:createSprite(options)
	elseif clsName == "ImageView" then
		node = self:createImage(options)
	elseif clsName == "Button" then
		node = self:createButton(options)
	elseif clsName == "LoadingBar" then
		node = self:createLoadingBar(options)
	elseif clsName == "Slider" then
		node = self:createSlider(options)
	elseif clsName == "CheckBox" then
		node = self:createCheckBox(options)
	elseif clsName == "LabelBMFont" then
		node = self:createBMFontLabel(options)
	elseif clsName == "Label" then
		node = self:createLabel(options)
	elseif clsName == "LabelAtlas" then
		node = self:createLabelAtlas(options)
	elseif clsName == "TextField" then
		node = self:createTextField(options)
	elseif clsName == "editbox" then
		node = self:createEditBox(options)
	elseif clsName == "Panel" then
		node = self:createPanel(options)
	elseif clsName == "ScrollView" then
		node = self:createScrollView(options)
	elseif clsName == "ListView" then
		node = self:createListView(options)
	elseif clsName == "PageView" then
		node = self:createPageView(options)
	elseif clsName == "Text" then
		node = self:createText(options)
	elseif clsName == "TextBMFont" then
		node = self:createTextBMFont(options)
	elseif clsName == "Particle" then
		node = self:createParticle(options)
	elseif clsName == "ProjectNode" then
		node = self:createProjectNdoe(options)
	else
		printInfo("CCSUICreator not support node:" .. clsName)
		assert(false, "CCSUICreator Not implemented " .. clsName)
	end
	return node
end
function CCSUICreator:applyCommonAttr(node, options)
	if not node then
		return
	end
	if options.x then
		node:setPositionX(options.x)
	end
	if options.y then
		node:setPositionY(options.y)
	end
	if options.anchorPointX and options.anchorPointY then
		node:setAnchorPoint(options.anchorPointX, options.anchorPointY)
	elseif options.anchorPointX then
		local an = node:getAnchorPoint()
		node:setAnchorPoint(options.anchorPointX, an.y)
	elseif options.anchorPointY then
		local an = node:getAnchorPoint()
		node:setAnchorPoint(an.x, options.anchorPointY)
	end
	if options.visible then
		node:setVisible(options.visible)
	end
	if options.ZOrder then
		node:setLocalZOrder(options.ZOrder)
	end
	if options.tag then
		node:setTag(options.tag)
	end
	if options.rotation then
		node:setRotation(options.rotation)
	end
	if options.opacity then
		node:setOpacity(options.opacity)
	end
	if options.flipX and node.setFlippedX then
		node:setFlippedX(options.flipX)
	end
	if options.flipY and node.setFlippedY then
		node:setFlippedY(options.flipY)
	end
	if options.touchAble then
		print("启用触摸-----")
		node:setTouchEnabled(true)
		node:setTouchSwallowEnabled(true)
	end
	if options.scale9Enable and node.setScale9Enabled then
		node:setScale9Enabled(true)
		node:setCapInsets(cc.rect(options.capInsetsX, options.capInsetsY, options.capInsetsWidth, options.capInsetsHeight))
		if node.ignoreContentAdaptWithSize then
			node:ignoreContentAdaptWithSize(false)
		end
	end
	if not options.ignoreSize then
		node:setContentSize(cc.size(options.width, options.height))
	end
	if options.color and node.setColor then
		node:setColor(options.color)
	end
end
function CCSUICreator:createNode(options)
	local node = cc.Node:create()
	self:applyCommonAttr(node, options)
	return node
end
function CCSUICreator:createSprite(options)
	local node = cc.Sprite:create()
	self:applyCommonAttr(node, options)
	if options.fileData.path then
		node:setSpriteFrame(options.fileData.path)
	end
	return node
end
function CCSUICreator:createImage(options)
	local node = ccui.ImageView:create()
	node:loadTexture(options.fileData.path, ccui.TextureResType.plistType)
	node:ignoreContentAdaptWithSize(false)
	self:applyCommonAttr(node, options)
	return node
end
function CCSUICreator:createButton(options)
	local node = ccui.Button:create()
	node:loadTextures(options.normalData.path, options.pressedData.path, options.disabledData.path, options.normalData.resType)
	self:applyCommonAttr(node, options)
	if options.textColor then
		node:setTitleColor(options.textColor)
	elseif options.textColorR and options.textColorG and textColorB then
		node:setTitleColor(cc.c3b(options.textColorR, options.textColorG, options.textColorB))
	end
	if options.fontSize then
		node:setTitleFontSize(options.fontSize)
	end
	if options.buttonText then
		node:setTitleText(options.buttonText)
	end
	return node
end
function CCSUICreator:createLoadingBar(options)
	local node = ccui.LoadingBar:create()
	if options.fileData then
		node:loadTexture(options.fileData.path, options.fileData.resType)
	end
	self:applyCommonAttr(node, options)
	if options.loadingBarDirection then
		node:setDirection(options.loadingBarDirection)
	end
	if options.pregressInfo then
		node:setPercent(options.pregressInfo)
	end
	return node
end
function CCSUICreator:createSlider(options)
	local node = ccui.Slider:create()
	if options.percentInfo then
		node:setPercent(options.percentInfo)
	end
	if options.ballNormalData then
		node:loadSlidBallTextures(options.ballNormalData.path, options.ballPressedData.path, options.ballDisabledData.path, options.ballNormalData.resType)
	end
	if options.backGroundData then
		node:loadBarTexture(options.backGroundData.path, options.backGroundData.resType)
	end
	if options.progressBarData then
		node:loadProgressBarTexture(options.progressBarData.path, options.progressBarData.resType)
	end
	self:applyCommonAttr(node, options)
	return node
end
function CCSUICreator:createCheckBox(options)
	local node = ccui.CheckBox:create()
	self:applyCommonAttr(node, options)
	if options.normalBackFileData then
		node:loadTextureBackGround(options.normalBackFileData.path, options.normalBackFileData.resType)
	end
	if options.pressedBackFileData then
		node:loadTextureBackGroundSelected(options.pressedBackFileData.path, options.pressedBackFileData.resType)
	end
	if options.disableBackFileData then
		node:loadTextureBackGroundDisabled(options.disableBackFileData.path, options.disableBackFileData.resType)
	end
	if options.nodeNormalFileData then
		node:loadTextureFrontCross(options.nodeNormalFileData.path, options.nodeNormalFileData.resType)
	end
	if options.nodeDisableFileData then
		node:loadTextureFrontCrossDisabled(options.nodeDisableFileData.path, options.nodeDisableFileData.resType)
	end
	return node
end
function CCSUICreator:createBMFontLabel(options)
	_ENV = nil
	;(nil).UILabelType = 1
	;(nil).text = options.text
	;(nil).font = options.fileNameData.path
	;(nil).textAlign = cc.ui.TEXT_ALIGN_CENTER
	local node = cc.ui.UILabel.new(nil)
	node:align(self:getAnchorType(options.anchorPointX or 0.5, options.anchorPointY or 0.5), options.x or 0, options.y or 0)
	return node
end
function CCSUICreator:createLabel(options)
	_ENV = nil
	;(nil).text = options.text
	;(nil).font = options.fontName
	;(nil).size = options.fontSize
	;(nil).color = cc.c3b(options.colorR or 255, options.colorG or 255, options.colorB or 255)
	;(nil).align = options.hAlignment
	;(nil).valign = options.vAlignment
	;(nil).dimensions = cc.size(options.areaWidth or 0, options.areaHeight or 0)
	;(nil).x = options.x
	;(nil).y = options.y
	local node = cc.ui.UILabel.new(nil)
	if not options.ignoreSize then
		node:setLayoutSize(options.areaWidth, options.areaHeight)
	end
	node:align(self:getAnchorType(options.anchorPointX or 0.5, options.anchorPointY or 0.5), options.x or 0, options.y or 0)
	return node
end
function CCSUICreator:createLabelAtlas(options)
	local labelAtlas
	if "function" == type(cc.LabelAtlas._create) then
		labelAtlas = cc.LabelAtlas:_create()
		labelAtlas:initWithString(options.stringValue, options.charMapFileData.path, options.itemWidth, options.itemHeight, string.byte(options.startCharMap))
	else
		labelAtlas = cc.LabelAtlas:create(options.stringValue, options.charMapFileData.path, options.itemWidth, options.itemHeight, string.byte(options.startCharMap))
	end
	self:applyCommonAttr(labelAtlas, options)
	return labelAtlas
end
function CCSUICreator:createTextField(options)
	local node = ccui.TextField:create()
	self:applyCommonAttr(node, options)
	if options.maxLength then
		node:setMaxLengthEnabled(true)
		node:setMaxLength(options.maxLength)
	end
	if options.placeHolder then
		node:setPlaceHolder(options.placeHolder)
	end
	if options.placeHolderColor then
		node:setPlaceHolderColor(options.placeHolderColor)
	end
	if options.passwordEnable then
		node:setPasswordEnabled(options.passwordEnable)
	end
	if options.text and node.setString then
		node:setString(options.text)
	end
	return node
end
function CCSUICreator:createEditBox(options)
	local node = ccui.EditBox:create(cc.size(options.width, options.height), node.fileData.path, ccui.TextureResType.plistType)
	self:applyCommonAttr(node, options)
	if options.fontColor then
		node:setFontColor(options.fontColor)
	end
	if options.maxLength then
		node:setMaxLength(options.maxLength)
	end
	if options.inputFlag then
		node:setInputFlag(options.inputFlag)
	end
	if options.placeHolder then
		node:setPlaceHolder(options.placeHolder)
	end
	return node
end
function CCSUICreator:applyPanelAttr(node, options)
	if options.opacity then
		node:setOpacity(options.opacity)
	end
	if 1 == options.colorType then
		node:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		node:setBackGroundColor(options.bgColor)
	elseif 2 == options.colorType then
		node:setBackGroundColorType(ccui.LayoutBackGroundColorType.gradient)
		node:setBackGroundColor(options.bgStartColor, options.bgEndColor)
		node:setBackGroundColorVector(cc.p(options.vectorX or 0, options.vectorY or -0.5))
	end
	node:setBackGroundColorOpacity(options.bgColorOpacity or 100)
	if options.fileData then
		node:setBackGroundImage(options.fileData.path, options.fileData.resType)
	end
	if options.scale9Enable and node.setBackGroundImageScale9Enabled then
		node:ignoreContentAdaptWithSize(false)
		node:setBackGroundImageScale9Enabled(true)
		node:setBackGroundImageCapInsets(cc.rect(options.capInsetsX, options.capInsetsY, options.capInsetsWidth, options.capInsetsHeight))
	end
end
function CCSUICreator:createPanel(options)
	local node = ccui.Layout:create()
	self:applyCommonAttr(node, options)
	self:applyPanelAttr(node, options)
	return node
end
function CCSUICreator:createScrollView(options)
	local node = ccui.ScrollView:create()
	self:applyCommonAttr(node, options)
	self:applyPanelAttr(node, options)
	if options.innerNodeSize then
		node:setInnerContainerSize(options.innerNodeSize)
	end
	if options.bounceEnabled then
		node:setBounceEnabled(options.bounceEnabled)
	end
	if options.scrollDirection then
		node:setDirection(options.scrollDirection)
	end
	return node
end
function CCSUICreator:createListView(options)
	local node = ccui.ListView:create()
	self:applyCommonAttr(node, options)
	self:applyPanelAttr(node, options)
	if options.scrollDirection then
		node:setDirection(options.scrollDirection)
	end
	if options.itemMargin then
		node:setItemsMargin(options.itemMargin)
	end
	return node
end
function CCSUICreator:createPageView(options)
	local node = ccui.PageView:create()
	self:applyCommonAttr(node, options)
	self:applyPanelAttr(node, options)
	return node
end
_ENV, CCSUICreator.createText = function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end, function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end
;(function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).HT_Center = cc.TEXT_ALIGNMENT_CENTER
;(function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).HT_Left = cc.TEXT_ALIGNMENT_LEFT
;(function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).HT_Right = cc.TEXT_ALIGNMENT_RIGHT
;(function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).VT_Center = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).VT_Top = cc.VERTICAL_TEXT_ALIGNMENT_TOP
local (function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end).VT_Bottom, textAlignIndex = cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM, function(self, options)
	local node = ccui.Text:create()
	node:setFontSize(options.fontSize)
	node:setColor(options.color or cc.c3b(255, 255, 255))
	if options.text then
		node:setString(options.text)
	end
	if options.isCustomSize then
		node:ignoreContentAdaptWithSize(false)
		node:setTextAreaSize(cc.size(options.width, options.height))
		node:setContentSize(cc.size(options.width, options.height))
	end
	node:setTextHorizontalAlignment(self:transTextAlign(options.textAlign) or cc.TEXT_ALIGNMENT_CENTER)
	node:setTextVerticalAlignment(self:transTextAlign(options.textVAlign) or cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	return node
end
function CCSUICreator:transTextAlign(textAlign)
	if type(textAlign) == "string" then
		return textAlignIndex[textAlign]
	end
	return textAlign
end
function CCSUICreator:createParticle(options)
	local node = cc.ParticleSystemQuad:create(options.fileData.path)
	self:applyCommonAttr(node, options)
	return node
end
function CCSUICreator:createTextBMFont(options)
	local node = ccui.TextBMFont:create()
	node:setFntFile(options.bmFontFileData.path)
	if options.text then
		node:setString(options.text)
	end
	self:applyCommonAttr(node, options)
	return node
end
function CCSUICreator:createProjectNdoe(options)
	local ccsFileName = SoraDStripExtension(SoraDGetFileName(options.fileData.path))
	local ccsFile = getCCSPath(ccsFileName)
	local node = cc.uiloader:load(ccsFile)
	self:applyCommonAttr(node, options)
	return node
end
return CCSUICreator
