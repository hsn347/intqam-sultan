local wiseTutorRead = include("wiseTutorRead")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local wiseTutorPreviewSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/wiseTutorPreviewSub", wiseTutorPreviewSub)
function wiseTutorPreviewSub:onInit()
	self.fields.Text_High:setString(i18n("Battle_Towers_13"))
	self.fields.Text_Normal:setString(i18n("Battle_Towers_18"))
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.List_special:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function wiseTutorPreviewSub:onShow()
	local normalAward, specialAward = wiseTutorRead.getAllAwardByIndex(wiseTutorCtrl:getLevelIndex())
	_ENV = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex()[1] = "id"
	wiseTutorCtrl:getLevelIndex()[2] = "count"
	self.normalAward = serviceFunctions.tableFormat(normalAward, wiseTutorCtrl:getLevelIndex())
	_ENV = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex()[1] = "id"
	wiseTutorCtrl:getLevelIndex()[2] = "count"
	self.specialAward = serviceFunctions.tableFormat(specialAward, wiseTutorCtrl:getLevelIndex())
	self.fields.List_normal:setNumItems(#self.normalAward)
	self.fields.List_normal:resizeToFit(#self.normalAward)
	self.fields.List_special:setNumItems(#self.specialAward)
	self.fields.List_special:resizeToFit(#self.specialAward)
end
function wiseTutorPreviewSub:onNormalItemRenderer(index, obj)
	local item = self.normalAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
function wiseTutorPreviewSub:onSpecialItemRenderer(index, obj)
	local item = self.specialAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
return wiseTutorPreviewSub
