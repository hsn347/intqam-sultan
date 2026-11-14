local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SpineTestPanel = class("SpineTestPanel", baseFguiPanel)
function SpineTestPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SpineTestPanel:ctor", self.viewName)
end
function SpineTestPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function SpineTestPanel:onInit()
	print("=======SpineTestPanel:onInit")
	_UPVALUE18_ = print
	self.spineList, print[1] = print, "13gongbing"
	self.spineList, print[2] = print, "13bubing"
	self.spineList, print[3] = print, "13chebing"
	self.spineList, print[4] = print, "13qibing"
	self.spineList, print[5] = print, "daxiang"
	self.spineList, print[6] = print, "dunbing1"
	self.spineList, print[7] = print, "dunbing2"
	self.spineList, print[8] = print, "dunbing3"
	self.spineList, print[9] = print, "heibaobubing"
	self.spineList, print[10] = print, "heibaonubing"
	self.spineList, print[11] = print, "heibaoqibing"
	self.spineList, print[12] = print, "huoqiangbing01"
	self.spineList, print[13] = print, "jingling01"
	self.spineList, print[14] = print, "jingling02"
	self.spineList, print[15] = print, "jingling03"
	self.spineList, print[16] = print, "jingling04"
	self.spineList, print[17] = print, "jingling05"
	self.spineList, print[18] = print, "qiangbing02"
	self.spineList, print[19] = print, "qibing1"
	self.spineList, print[20] = print, "xiangbing01"
end
function SpineTestPanel:onShow()
	print("=======SpineTestPanel:onShow")
	self.idx = 1
	self.fields.n1:addClickEventListener(function()
		self.idx = self.idx - 1
		if self.idx <= 0 then
			self.idx = 1
		end
		self:updateView()
	end)
	self.fields.n2:addClickEventListener(function()
		self.idx = self.idx + 1
		if self.idx > #self.spineList then
			self.idx = #self.spineList
		end
		self:updateView()
	end)
	self:updateView()
end
function SpineTestPanel:onHide()
	print("=======SpineTestPanel:onHide")
end
function SpineTestPanel:onDispose()
	print("=======SpineTestPanel:onDispose")
end
function SpineTestPanel:updateView()
	local spineName = self.spineList[self.idx]
	self.fields.name:setString(spineName)
	self.fields.Spine_1:setEffectPath("spine/soldiers2/" .. spineName .. ".skel")
end
return SpineTestPanel
