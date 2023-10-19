using Godot;

namespace KaelLevel3Game.source;

public partial class Chunk : MeshInstance3D
{
	private const int ChunkWidth = 32;
	private const int ChunkHeight = 32;
	private const int ChunkDepth = 32;
	
	private byte[] _voxels = new byte[ChunkWidth * ChunkHeight * ChunkDepth];
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready(){
		GenerateTerrain();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void GenerateTerrain(){
		const int chunkHeightDepth = ChunkHeight * ChunkDepth; // Precompute height and depth multiplication.
		GD.Print("start");
		for (int x = 0; x < ChunkWidth; x++){
			for (int z = 0; z < ChunkDepth; z++){
				// 2D terrain here
				for (int y = 0; y < ChunkHeight; y++){
					// 3D terrain here
					int i = chunkHeightDepth * x + ChunkHeight * z + y;
					_voxels[i] = 2;
					//GD.Print(i);
				}
			}
		}
		GD.Print("done");
	}
	
}