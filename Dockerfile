# =======================================================
# Stage 1 - Build/compile app using container
# =======================================================
ARG IMAGE_BASE=9.0-alpine

# Build image has SDK and tools (Linux)
FROM mcr.microsoft.com/dotnet/sdk:$IMAGE_BASE as build
WORKDIR /build

# Copy project source files
COPY BlazorWeb ./src

# Restore, build & publish
WORKDIR /build/src
RUN dotnet restore
RUN dotnet publish --no-restore --configuration Release

# =======================================================
# Stage 2 - Assemble runtime image from previous stage
# =======================================================

# Base image is .NET Core runtime only (Linux)
FROM mcr.microsoft.com/dotnet/aspnet:$IMAGE_BASE

# Seems as good a place as any
WORKDIR /app

# Copy already published binaries (from build stage image)
COPY --from=build /build/src/bin/Release/net9.0/publish/ .

# Expose port 5000 from Kestrel webserver
EXPOSE 5000

# Tell Kestrel to listen on port 5000 and serve plain HTTP
ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT Production
# This is critical for the Azure AD signin flow to work in Kubernetes and App Service
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true

# Run the ASP.NET Core app
ENTRYPOINT dotnet BlazorWeb.dll
