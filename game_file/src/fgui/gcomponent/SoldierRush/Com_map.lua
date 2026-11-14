local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_map", Com_map)
function Com_map:onInit()
	self.showModel = 0
	self.zoomScale = 1.67
	self:getScrollPane():setBouncebackEffect(false)
end
function Com_map:onShow()
	for i = 1, 10 do
		local png = string.format("SinglePicture/frame_chaptermap_new_%.2d.png", i)
		self.fields["Image_chapter_" .. i]:getChild("icon"):setTexture(png)
		self.fields["Image_chapter_" .. i]:setTag(i)
		self.fields["Image_chapter_" .. i]:addClickListener(handler(self, self.onChapterClick))
		self.fields["box" .. i]:setTag(i)
		self.fields["box" .. i]:setVisible(false)
		self.fields["box" .. i]:addClickListener(handler(self, self.onBoxClick))
	end
end
function Com_map:setChapterInfo()
	for i = 1, 10 do
		self.fields["chapter_" .. i]:initData(i)
		local status, stars = soldierRushCtrl:getChpaterInfo(i)
		local ret = soldierRushCtrl:isHaveChapterBox(i, stars)
		self.fields["box" .. i]:setVisible(ret and self.showModel == 0)
	end
end
function Com_map:hideBox()
	for i = 1, 10 do
		self.fields["box" .. i]:setVisible(false)
	end
end
function Com_map:setGateModel(chapter)
	for i = 1, 10 do
		self.fields["Image_chapter_" .. i]:setShowModel(self.showModel, i)
		if chapter then
			if i == chapter then
				self.fields["Image_chapter_" .. i]:getChild("icon"):setColor(cc.c3b(255, 255, 255))
				self.fields["Image_chapter_" .. i]:setTouchEnabled(true)
				self.fields["Image_chapter_" .. i]:setGateAndPath(self.showModel == 1)
			else
				self.fields["Image_chapter_" .. i]:getChild("icon"):setColor(cc.c3b(120, 120, 120))
				self.fields["Image_chapter_" .. i]:setTouchEnabled(false)
				self.fields["Image_chapter_" .. i]:setGateAndPath(false)
			end
		else
			self.fields["Image_chapter_" .. i]:getChild("icon"):setColor(cc.c3b(255, 255, 255))
			self.fields["Image_chapter_" .. i]:setTouchEnabled(true)
			self.fields["Image_chapter_" .. i]:setGateAndPath(self.showModel == 1)
		end
	end
end
function Com_map:showGateMap(chapter)
	self.showModel = 1
	if G_IS_UNITY then
		self:getScrollPane():setScale(self.zoomScale)
	else
		self:getScrollPane():setZoomScale(self.zoomScale)
	end
	self:setChapterVisible(false)
	self:setGateModel(chapter)
	self:getScrollPane():setTouchEffect(false)
	self:hideBox()
end
function Com_map:showChapterMap()
	self.showModel = 0
	if G_IS_UNITY then
		self:getScrollPane():setScale(1)
	else
		self:getScrollPane():setZoomScale(1)
	end
	self:setChapterVisible(true)
	self:setChapterInfo()
	self:setGateModel()
	self:getScrollPane():setTouchEffect(true)
end
function Com_map:getZoomScale()
	return self.zoomScale
end
function Com_map:setOffsetPos(pos)
	self:getScrollPane():setPosX(pos.x)
	self:getScrollPane():setPosY(pos.y)
end
function Com_map:getChapter(id)
	return self.fields["Image_chapter_" .. id]
end
function Com_map:getGate(chapter, id)
	return self.fields["Image_chapter_" .. chapter]:getGate(id)
end
function Com_map:setChapterVisible(ret)
	for i = 1, 10 do
		self.fields["chapter_" .. i]:setVisible(ret)
	end
end
function Com_map:onChapterClick(context)
	SoraDPlaySound()
	local chapter = context:getSender():getTag()
	local status, stars = soldierRushCtrl:getChpaterInfo(chapter)
	local cfg = soldierRushRead.getChapterCfg(chapter)
	if status == 0 then
		_ENV = nil
		;(nil).num = cfg.FrontChapter
		SoraDShowMsgTip(i18n("soldier_rush_text_04", nil))
	else
		_ENV = i18n("soldier_rush_text_04", nil)
		i18n("soldier_rush_text_04", nil).msg = "MESSAGE_SOLDIERRUSH_UI_CHAPTER_MODEL"
		i18n("soldier_rush_text_04", nil).chapter = chapter
		SoraDSendMessage(i18n("soldier_rush_text_04", nil))
	end
end
function Com_map:onBoxClick(context)
	SoraDPlaySound()
	local chapter = context:getSender():getTag()
	soldierRushCtrl:sendRewardAll(chapter)
end
return Com_map
