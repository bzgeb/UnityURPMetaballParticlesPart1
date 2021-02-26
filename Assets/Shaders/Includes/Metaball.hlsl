#ifndef METABALL_INCLUDE
#define METABALL_INCLUDE
// Credit to Scratchapixel at
// https://www.scratchapixel.com/lessons/advanced-rendering/rendering-distance-fields/basic-sphere-tracer
// for the explanation on Metaballs and example code

float GetDistanceSphere(float3 from, float3 center, float radius)
{
    return length(from - center) - radius;
}

void SphereTraceMetaballs_float(float3 WorldPosition, out float Alpha)
{
    #if defined(SHADERGRAPH_PREVIEW)
    Alpha = 1;
    #else
    float maxDistance = 100;
    float threshold = 0.00001;
    float t = 0;
    int numSteps = 0;
    
    float outAlpha = 0;
    
    float3 viewPosition = GetCurrentViewPosition();
    half3 viewDir = SafeNormalize(WorldPosition - viewPosition);
    while (t < maxDistance)
    {
        float minDistance = 1000000;
        float3 from = viewPosition + t * viewDir;
        float d = GetDistanceSphere(from, float3(0, 0, 0), 0.2);
        if (d < minDistance)
        {
            minDistance = d;
        }
    
        if (minDistance <= threshold * t)
        {
            outAlpha = 1;
            break;
        }
    
        t += minDistance;
        ++numSteps;
    }
    
    Alpha = outAlpha;
    #endif
}

#endif
