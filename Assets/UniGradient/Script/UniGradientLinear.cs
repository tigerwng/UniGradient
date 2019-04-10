/*
 * @Author: zhen wang 
 * @Date: 2018-09-06 21:22:11 
 * @Last Modified by: zhen wang
 * @Last Modified time: 2018-09-06 21:25:57
 */


using UnityEngine;


namespace tiger.UniGradient
{
    [ExecuteInEditMode]
    [DisallowMultipleComponent]
    public class UniGradientLinear : MonoBehaviour
    {
        const int defaultColorCount = 5;

        public Material gradientMat;

        public float colorCount;

        public Color[] colors = new Color[defaultColorCount];

        public float[] positions = new float[defaultColorCount];


        void Awake()
        {
            this.UpdateMaterial();
        }

        void UpdateMaterial()
        {
            try
            {
                gradientMat.SetFloat("_ColorCount", colorCount);
                gradientMat.SetColorArray("_Colors", colors);
                gradientMat.SetFloatArray("_Positions", positions);
            }
            catch(System.Exception e)
            {
                Debug.LogWarning(e.Message);
            }
        }

        public void SetGradient(float colorCount, Color[] colors, float[] positions)
        {
            this.colorCount = colorCount;
            this.colors = colors;
            this.positions = positions;

            this.UpdateMaterial();
        }

        void OnValidate()
        {
            this.UpdateMaterial();
        }
    }
}

