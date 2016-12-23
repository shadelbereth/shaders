using UnityEngine;
using System.Collections;

public class GrassGenerator : MonoBehaviour {
    public float minX = -5f;
    public float maxX = 5f;
    public float minZ = -5f;
    public float maxZ = 5f;
    public int grassNbr = 500;
    public float minWidth = 0.2f;
    public float maxWidth = 0.4f;
    public float minHeight = 0.3f;
    public float maxHeight = 0.5f;

    public float minHue = 0.1f;
    public float maxHue = 0.3f;
    public float minSat = 0.7f;
    public float maxSat = 1f;
    public float minVal = 0.5f;
    public float maxVal = 1f;

    private Mesh grassGeometry;

    public void Generate () {
        if (grassGeometry != null) {
            DestroyImmediate(grassGeometry);
        }
        grassGeometry = new Mesh();
        int verticeNbr = grassNbr * 4;
        int triangleNbr = grassNbr * 2;
        Vector3[] vertices = new Vector3[verticeNbr];
        Vector3[] normals = new Vector3[verticeNbr];
        Vector2[] uvs = new Vector2[verticeNbr];
        Color[] colors = new Color[verticeNbr];
        int[] triangles = new int[triangleNbr * 3];

        for (int i = 0; i < grassNbr; i++) {
            Vector3 spawnPos = new Vector3(Random.Range(minX, maxX), 0f, Random.Range(minZ, maxZ));
            float angle = Random.Range(0f, Mathf.PI * 2f);
            Vector3 rightPos = new Vector3 (Mathf.Sin(angle), 0f, Mathf.Cos(angle));
            rightPos *= Random.Range(minWidth, maxWidth);

            float height = Random.Range(minHeight, maxHeight);

            vertices[i*4] = spawnPos + rightPos;
            vertices[i*4 + 1] = spawnPos - rightPos;
            vertices[i*4 + 2] = spawnPos - rightPos + Vector3.up * height;
            vertices[i*4 + 3] = spawnPos + rightPos + Vector3.up * height;

            // Vector3 normal = new Vector3[rightPos.z, 0f, rightPos.z];

            normals[i*4] = Vector3.up;
            normals[i*4 + 1] = Vector3.up;
            normals[i*4 + 2] = Vector3.up;
            normals[i*4 + 3] = Vector3.up;

            uvs[i*4] = new Vector2(1f, 0f);
            uvs[i*4 + 1] = new Vector2(0f, 0f);
            uvs[i*4 + 2] = new Vector2(0f, 1f);
            uvs[i*4 + 3] = new Vector2(1f, 1f);

            Color grassColor = Random.ColorHSV(minHue, maxHue, minSat, maxSat, minVal, maxVal);
            colors[i*4] = grassColor;
            colors[i*4 + 1] = grassColor;
            colors[i*4 + 2] = grassColor;
            colors[i*4 + 3] = grassColor;

            int baseIndex = i * 4;

            triangles[i*6] = baseIndex + 0;
            triangles[i*6 + 1] = baseIndex + 2;
            triangles[i*6 + 2] = baseIndex + 1;

            triangles[i*6 + 3] = baseIndex + 0;
            triangles[i*6 + 4] = baseIndex + 3;
            triangles[i*6 + 5] = baseIndex + 2;
        }

        grassGeometry.vertices = vertices;
        grassGeometry.colors = colors;
        grassGeometry.normals = normals;
        grassGeometry.uv = uvs;
        grassGeometry.triangles = triangles;
        MeshFilter meshFilter = gameObject.GetComponent<MeshFilter>();
        if (meshFilter == null) {
            meshFilter = gameObject.AddComponent<MeshFilter>();
        }
        meshFilter.mesh = grassGeometry;
        MeshRenderer meshRenderer = gameObject.GetComponent<MeshRenderer>();
        if (meshRenderer == null) {
            meshRenderer = gameObject.AddComponent<MeshRenderer>();
        }
    }

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
