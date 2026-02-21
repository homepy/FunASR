import os
from funasr.auto.auto_model import AutoModel
 
def export_to_torchscript(model_name, export_dir="./export", device="cpu"):
    """
    导出FunASR模型为TorchScript格式
    
    Args:
        model_name: 模型名称
        export_dir: 导出目录
        device: 设备类型 "cpu", "cuda", "xpu", "mps"
    """
    try:
        # 创建导出目录
        os.makedirs(export_dir, exist_ok=True)
        
        print(f"正在加载模型: {model_name}")
        model = AutoModel(
            model=model_name,
            device=device
        )
        
        print("正在导出为TorchScript...")
        export_path = model.export(
            type="torchscript",
            quantize=False
        )
        
        print(f"导出成功！模型保存在: {export_path}")
        
        # 列出导出的文件
        print("\n导出文件列表:")
        for root, dirs, files in os.walk(export_path):
            for file in files:
                print(f"  - {os.path.join(root, file)}")
                
        return export_path
        
    except Exception as e:
        print(f"导出失败: {str(e)}")
        raise
 
# 执行导出
if __name__ == "__main__":
    model_name = "iic/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"
    export_to_torchscript(model_name, export_dir="/root/shared-nvme/test", device="cuda")