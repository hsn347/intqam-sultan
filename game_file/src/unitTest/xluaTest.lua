local xlua = _G.xlua
assert(xlua.sethook, "xlua.sethook")
assert(xlua.structclone, "xlua.structclone")
assert(xlua.setpeer, "xlua.setpeer")
assert(xlua.getpeer, "xlua.getpeer")
local unity_vector2 = _G.CS.UnityEngine.Vector2
assert(unity_vector2.Distance, "unity_vector2.Distance")
function unity_vector2:addFunc()
	print("addFun", self.x, self.y)
end
print(unity_vector2.addFunc, "unity_vector2.addFunc")
local vec2 = _G.classEx("vec2", function()
	return unity_vector2(0, 0)
end)
function vec2:test()
	print("test func", self.x, self.y)
	print("test func", self)
	self.x = 1.0
	self.y = 1.0
	print("test func", self.x, self.y)
	print("test func", self)
	print("test extend getfunc width", self.width, self.height)
	self.width = 2.0
	self.height = 2.0
	print("test extend setfunc width", self.width, self.height)
	print("test extend setfunc width", self.x, self.y)
	self:Set(1.0, 2.0)
	print("test Set func", self.x, self.y)
end
local v = vec2.new()
local meta = getmetatable(v)
print(meta, "meta")
print(unity_vector2.addFunc, "unity_vector2.addFunc")
v:test()
v:addFunc()
local unity_obj = _G.CS.UnityEngine.GameObject
function unity_obj:addFunc()
	print("addFun", self)
end
print(unity_obj.addFunc, "unity_obj.addFunc")
local obj2 = _G.class("obj2", unity_obj)
for k, v in pairs(unity_obj) do
	print("====#====", k, v, type(v))
end
function obj2:test()
	print("test func", self)
	print("test func", self)
	print("============", self:GetComponent("123"), self.GetComonent)
end
local vobj = obj2.new()
local metaobj = getmetatable(vobj)
print(metaobj, "metaobj")
print(unity_obj.addFunc, "unity_obj.addFunc")
vobj:test()
vobj:addFunc()
_ENV = vobj.addFunc
local vobj.addFunc.testIndex, index = "test--index222", vobj.addFunc
_ENV, _ENV = print, "unity_obj.addFunc"
print.__index = index
local table1 = setmetatable("unity_obj.addFunc", print)
function table1:addFunc()
	print(self, "addFunc == table1")
end
local vobj1 = unity_obj()
xlua.setpeer(vobj1, table1)
assert(xlua.getpeer(vobj1) == table1, "getpeer failed")
print(vobj1.testIndex)
vobj1:addFunc()
local GObject = CS.FairyGUI.GObject
print(GObject, "GObject")
function GObject.abc()
	print("GObject:abc")
end
print("GObject1.abc", GObject.abc)
local GComponent = CS.FairyGUI.GComponent
print(GComponent, "GComponent")
function GComponent.abc()
	print("GComponent:abc")
end
print("GComponent1.abc", GComponent.abc)
print("==================111")
print("GObject.abc", GObject.abc)
print("GComponent.abc", GComponent.abc)
GObject.abc()
GComponent.abc()
