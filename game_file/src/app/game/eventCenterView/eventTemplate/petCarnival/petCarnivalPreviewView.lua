local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalRead = include("petCarnivalRead")
local petCarnivalPreviewView = class("petCarnivalPreviewView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petCarnivalPreviewView")
	end
	return target
end)
function petCarnivalPreviewView:ctor()
	self.award, _ENV = nil, nil
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ScrollView_item = SoraDGetChildByName(self, "ScrollView_item")
	self.ScrollView_item = include("commonAutoScrollList").new(self.ScrollView_item)
	self.ScrollView_item:setSingleCCS("petCarnivalPreviewItem")
	self.commonPopBox:setTitleName(i18n("pet_flip_text_09"))
	self:initData()
end
function petCarnivalPreviewView:initData()
	local data = petCarnivalRead:getConfig()
	petCarnivalRead = nil
	;(nil).scroll = self.ScrollView_item
	;(nil).view = self
	self.ScrollView_item:updateScrollView(cc.size(525, 189), data, 1, nil)
end
function petCarnivalPreviewView:reverseTable(tab)
	local _ENV, tmp
	local tabClone = clone(tab)
	for i = 1, #tabClone do
		tmp[i] = table.remove(tabClone)
	end
	return tmp
end
return petCarnivalPreviewView
