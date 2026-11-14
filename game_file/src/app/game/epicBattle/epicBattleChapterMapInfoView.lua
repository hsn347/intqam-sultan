local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleDef = include("epicBattleDef")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleChapterMapInfoView = class("epicBattleChapterMapInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleChapterMapInfoView")
	end
	return target
end)
function epicBattleChapterMapInfoView:ctor()
	self:setSwallowTouches(false)
	self:setAnchorPoint(cc.p(0, 0))
	self.isChapterDetail = false
	self.pathSpareArray, _ENV, self.pathArray, _ENV, self.gateSpareArray, _ENV, self.gateArray, _ENV, self.chapterImgArray, _ENV, self.chapterSingleArray, _ENV, self.chapterInfo, _ENV, self.viewSize = cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610), cc.size(640, 1610)
	SoraDGetChildByName(self, "Center_Size_Tile_Image_bg"):setFillType(1)
	self.Center_Node_map = SoraDGetChildByName(self, "Center_Node_map")
	self.Center_Node_path = SoraDGetChildByName(self, "Center_Node_path")
	self.Node_chapters = SoraDGetChildByName(self, "Node_chapters")
	self.Node_chapters:setLocalZOrder(20)
	for i = 1, 10 do
		self.chapterSingleArray[i] = SoraDGetExtendChildFromCCSByName(self.Node_chapters, "CCS_epicBattleChapterInfo_" .. i)
		local img_chapter = SoraDGetChildByName(self.Center_Node_map, "Image_chapter_" .. i)
		local realPng = string.format("SinglePicture/frame_chaptermap_new_%.2d.png", i)
		self.chapterImgArray[i] = ccui.ImageView:create(realPng, ccui.TextureResType.localType)
		self.chapterImgArray[i]:setPosition(img_chapter:getPositionX(), img_chapter:getPositionY())
		self.chapterImgArray[i]:setScaleX(img_chapter:getScaleX())
		self.chapterImgArray[i]:setScaleY(img_chapter:getScaleY())
		self.chapterImgArray[i]:setTouchEnabled(true)
		self.chapterImgArray[i]:setSwallowTouches(false)
		self.chapterImgArray[i]:setTag(i)
		self.chapterImgArray[i]:setPreciseTouchEnabled(true)
		self.chapterImgArray[i]:addTouchEventListener(handler(self, self.chapterImgClick))
		self.chapterImgArray[i]:addTo(self.Center_Node_map, 0)
		img_chapter:setVisible(false)
	end
end
function epicBattleChapterMapInfoView:setScroll(scroll)
	self.scroll = scroll
end
function epicBattleChapterMapInfoView:setDark(chapter)
	for k, v in ipairs(self.chapterImgArray) do
		v:setColor((not chapter or chapter == k) and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	end
end
function epicBattleChapterMapInfoView:showNewestChapter(chapter)
	if self.chapterImgArray[chapter] then
		if self.imgBorder then
			self.imgBorder:removeFromParent()
			self.imgBorder = nil
		end
		self.imgBorder = display.newSprite(string.format("SinglePicture/frame_chaptermap_new_%.2d.png", chapter))
		self.imgBorder:addTo(self.Center_Node_map, 9)
		self.imgBorder:setPosition(self.chapterImgArray[chapter]:getPositionX(), self.chapterImgArray[chapter]:getPositionY())
		self.imgBorder:setScale(0.725)
		SoraDCreateStrokeSprite(self.imgBorder, cc.c3b(0, 255, 0), 0.002, 1.0E-5)
	end
	for k, v in ipairs(self.chapterSingleArray) do
		v:setEffectVisible(chapter == k)
	end
end
function epicBattleChapterMapInfoView:showChapterInfo(ret)
	self.Node_chapters:setVisible(ret)
end
function epicBattleChapterMapInfoView:showGateInfo(ret)
	self.Center_Node_path:setVisible(ret)
end
function epicBattleChapterMapInfoView:isPosInArea(pos, area)
	local isIn = false
	if pos.x <= area.x + area.w and pos.x >= area.x and pos.y <= area.y + area.h and pos.y >= area.y then
		isIn = true
	end
	return isIn
end
function epicBattleChapterMapInfoView:setGateArrayEffect(gateData)
	for k, v in pairs(self.gateArray) do
		v:setEffectVisible(v:getStage() == gateData.stage)
	end
end
function epicBattleChapterMapInfoView:initPath()
	for k, v in ipairs(epicBattleDef.pathData) do
		if not self.pathArray[k] then
			self.pathArray[k] = display.newSprite("#frame_sszz_way_02.png")
			self.pathArray[k]:addTo(self.Center_Node_path, 1)
			self.pathArray[k]:setScale(0.4)
			self.pathArray[k]:setOpacity(204.0)
			self.pathArray[k]:setPosition(v.pos.x, v.pos.y)
			local gateID = epicWarltCtrl.getStagesID(v.chapter, v.gate)
			print("v.chapter,v.gate======", v.chapter, v.gate, gateID)
			local gateInfo = epicWarCtrl:getStageEntityInfo(gateID)
			if gateInfo.isCanChallenge then
				self.pathArray[k]:setSpriteFrame("frame_sszz_way_03.png")
			end
		end
	end
end
function epicBattleChapterMapInfoView:updatePath()
	for k, v in ipairs(epicBattleDef.pathData) do
		if self.pathArray[k] then
			local gateID = epicWarltCtrl.getStagesID(v.chapter, v.gate)
			local gateInfo = epicWarCtrl:getStageEntityInfo(gateID)
			if gateInfo.isCanChallenge then
				self.pathArray[k]:setSpriteFrame("frame_sszz_way_03.png")
			end
		end
	end
end
function epicBattleChapterMapInfoView:initGate(curChapter)
	local offset = self.scroll:getContentOffset()
	local zoomScale = self.scroll:getZoomScale()
	_ENV = self.scroll
	self.scroll.x = math.abs(offset.x + 60) / zoomScale
	self.scroll.y = math.abs(offset.y + 100) / zoomScale
	self.scroll.w = 60 + display.width / zoomScale
	local self.scroll.h, viewArea = 100 + display.height / zoomScale, self.scroll
	for k, v in ipairs(epicBattleDef.gateData) do
		local offPos = cc.p(v.pos.x + self.viewSize.width / 2, v.pos.y + self.viewSize.height / 2)
		local isIn = self:isPosInArea(offPos, viewArea)
		if not self.gateArray[k] and isIn then
			self.gateArray[k] = include("epicWarGate").new()
			self.gateArray[k]:addTo(self.Center_Node_path, 2)
			self.gateArray[k]:setScale(0.4)
			self.gateArray[k]:setPosition(v.pos.x, v.pos.y)
			local index = k % 10 == 0 and 10 or k % 10
			local gateID = epicWarltCtrl.getStagesID(v.chapter, index)
			self.gateArray[k]:initData(gateID)
		end
		if self.gateArray[k] then
			self.gateArray[k]:setDark(curChapter)
		end
	end
end
function epicBattleChapterMapInfoView:updateGate(gateID)
	for k, v in pairs(self.gateArray) do
		v:initData(v:getStage())
	end
end
function epicBattleChapterMapInfoView:setChaptersInfo(info)
	self.chapterInfo = info or epicWarCtrl:getAllChapterInfo()
	for k, v in ipairs(self.chapterSingleArray) do
		v:initData(self.chapterInfo[k])
	end
end
function epicBattleChapterMapInfoView:getContentSize()
	return self.viewSize
end
function epicBattleChapterMapInfoView:getChapterImg(chapter)
	return self.chapterImgArray[chapter]
end
function epicBattleChapterMapInfoView:setIsChapterDetail(ret)
	self.isChapterDetail = ret
end
function epicBattleChapterMapInfoView:getGate(gate)
	for k, v in pairs(self.gateArray) do
		if v:getStage() == gate then
			return v
		end
	end
end
function epicBattleChapterMapInfoView:chapterImgClick(target, event, isTest)
	if event == ccui.TouchEventType.ended then
		if self.isMoved then
			self.isMoved = false
			return
		end
		if self.isChapterDetail then
			return
		end
		if not isTest then
			SoraDPlaySound()
		end
		local chapterInfo = epicWarCtrl:getCurChapterInfo(target:getTag())
		if chapterInfo.isUnlock then
			_ENV = target:getTag()
			target:getTag().msg = "MESSAGE_UI_EPICBATTLE_CHAPTER_SELECT"
			target:getTag().chapter = target:getTag()
			SoraDSendMessage(target:getTag())
			self.isChapterDetail = true
			self:showNewestChapter(target:getTag())
			self:setDark(target:getTag())
		elseif chapterInfo.needLv > SoraDGetCastleLv() then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(chapterInfo.needLv)
			if isShowWarLv then
				_ENV = target:getTag()
				target:getTag().lv = textLv
				if i18n("common_text_1948", target:getTag()) then
					goto lbl_62
				end
			end
			local str = chapterInfo.needLv
			::lbl_62::
			_ENV = target:getTag()
			target:getTag().level = str
			SoraDShowMsgTip(i18n("epicbattle_text_02", target:getTag()))
		else
			local preChapterInfo = epicWarCtrl:getCurChapterInfo(chapterInfo.index - 1)
			if preChapterInfo and not preChapterInfo.isPass then
				_ENV = i18n("epicbattle_text_02", target:getTag())
				i18n("epicbattle_text_02", target:getTag()).num = chapterInfo.index - 1
				SoraDShowMsgTip(i18n("epicbattle_text_01", i18n("epicbattle_text_02", target:getTag())))
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.isMoved = false
	end
end
return epicBattleChapterMapInfoView
