local epicWarChapterSelectSingle = class("epicWarChapterSelectSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarChapterSelectSingle")
	end
	return target
end)
function epicWarChapterSelectSingle:ctor()
	self.Text_chapter = SoraDGetChildByName(self, "Text_chapter")
	self.Button_select = SoraDGetChildByName(self, "Button_select")
	self.Button_select:setSwallowTouches(false)
	self.Button_select = include("commonBtnInstance").new(self.Button_select)
	self.Button_select:setHandle(handler(self, self.btnSelectCallBack))
end
function epicWarChapterSelectSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.handle = otherData.handle
	self.curChapter = otherData.curChapter
	_ENV = nil
	;(nil).num = self.data.index
	self.Text_chapter:setString(i18n("common_text_3162", nil))
	self.Text_chapter:setColor(self.curChapter == self.data.index and cc.c3b(255, 251, 236) or cc.c3b(215, 195, 155))
	self.Button_select:setScroll(self.scroll)
end
function epicWarChapterSelectSingle:btnSelectCallBack()
	if self.handle then
		self.handle(self.data)
	end
end
return epicWarChapterSelectSingle
